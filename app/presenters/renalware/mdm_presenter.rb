# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
require_dependency "renalware/clinics"

module Renalware
  class MDMPresenter
    NullAccess = Naught.build do |config|
      config.black_hole
      config.define_explicit_conversions
      config.singleton
      config.predicates_return false
    end

    attr_reader :patient, :view_context

    def initialize(patient:, view_context:)
      @patient = patient
      @view_context = view_context
    end

    def pathology
      @pathology ||= pathology_for_codes
    end

    def pathology_for_codes(codes = nil)
      Pathology::CreateObservationsGroupedByDateTable.new(
        patient: patient,
        observation_descriptions: pathology_descriptions_for_codes(codes),
        page: 1,
        per_page: 10
      ).call
    end

    def clinic_visits(limit: 6)
      @clinic_visits ||= Clinics::ClinicVisit.for_patient(patient)
                                             .includes(:clinic)
                                             .with_created_by
                                             .ordered
                                             .limit(limit)
    end

    def clinic_visits_having_measurements(limit: 3)
      @clinic_visits_having_measurements ||= begin
        Clinics::ClinicVisit
          .for_patient(patient)
          .where("height is not null "\
                 "or weight is not null "\
                 "or systolic_bp is not null "\
                 "or diastolic_bp is not null")
          .ordered
          .limit(limit)
      end
    end

    def historical_prescriptions
      @historical_prescriptions ||= execute_prescriptions_query(patient.prescriptions)
    end

    def current_prescriptions
      @current_prescriptions ||= begin
        execute_prescriptions_query(patient.prescriptions.current)
      end
    end

    def current_immunosuppressant_prescriptions
      @current_immunosuppressant_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type(:immunosuppressant).current
        )
      end
    end

    def historical_immunosuppressant_prescriptions
      @historical_immunosuppressant_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type(:immunosuppressant)
        )
      end
    end

    # Note we sort prescriptions by prescribed_on desc here manually because the
    # prescriptions query is currently too complex to add another sql sort into (defaults)
    # to sorting by drug name
    def esa_prescriptions
      @esa_prescriptions ||= begin
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type("esa")
        ).sort_by(&:prescribed_on).reverse!
      end
    end

    def current_problems
      @current_problems ||= patient.problems.current.limit(6).with_created_by.ordered
    end

    # rubocop:disable Lint/UnusedMethodArgument
    def events_of_type(type: nil)
      Events::Event.for_patient(patient).includes([:created_by, :event_type]).limit(6).ordered
    end
    # rubocop:enable Lint/UnusedMethodArgument
    alias_method :events, :events_of_type

    def letters
      patient_ = Renalware::Letters.cast_patient(patient)
      letters_ = patient_.letters
                         .ordered
                         .with_main_recipient
                         .with_letterhead
                         .with_author
                         .with_event
                         .with_patient
                         .limit(6)

      CollectionPresenter.new(letters_, Renalware::Letters::LetterPresenterFactory)
    end

    def current_pathology_for_code(code)
      result = OpenStruct.new(value: nil, date: nil)
      hash = patient.current_observation_set&.values_for_codes(code) || {}
      obs = hash[code]
      if obs.present?
        result.value = obs["result"]
        result.date = obs["observed_at"]
        result.date = Date.parse(result.date)
      end
      result
    end

    def current_transplant_status
      @current_transplant_status ||= begin
        Renalware::Transplants::Registration.for_patient(patient).first&.current_status
      end
    end

    def access
      @access ||= begin
        access_profile = Renalware::Accesses.cast_patient(patient).current_profile
        if access_profile.present?
          Accesses::ProfilePresenter.new(access_profile)
        else
          NullAccess.instance
        end
      end
    end

    private

    def pathology_descriptions_for_codes(codes)
      if codes.nil?
        Pathology::RelevantObservationDescription.all
      else
        codes = Array(codes)
        descriptions = Pathology::ObservationDescription.for(Array(codes))
        warn("No OBX(es) found for codes #{codes}") if descriptions.empty?
        descriptions
      end
    end

    def pathology_patient
      Renalware::Pathology.cast_patient(patient)
    end

    def execute_prescriptions_query(relation)
      query = Medications::PrescriptionsQuery.new(relation: relation)
      query.call
           .with_created_by
           .with_medication_route
           .with_drugs
           .with_classifications
           .eager_load(drug: [:drug_types])
           .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
    end
  end
end
# rubocop:enable Metrics/ClassLength
