# rubocop:disable Metrics/ClassLength
require_dependency "renalware/clinics"

module Renalware
  class MDMPresenter
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

    # Note we sort prescriptions by prescribed_on desc here manually because the
    # prescriptions query is currently too complex to add another sql sort into (defaults)
    # to sorting by drug name
    def current_prescriptions
      @current_prescriptions ||= begin
        # TODO: maybe use #sort_by(:prescribed_on) here
        execute_prescriptions_query(patient.prescriptions.current)
          .sort{ |presc1, presc2| presc2.prescribed_on <=> presc1.prescribed_on }
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
        # TODO: maybe use #sort_by(:prescribed_on) here
        execute_prescriptions_query(
          patient.prescriptions.having_drug_of_type("esa")
        ).sort{ |presc1, presc2| presc2.prescribed_on <=> presc1.prescribed_on }
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
                         .order(issued_on: :desc)
                         .with_main_recipient
                         .with_letterhead
                         .with_author
                         .with_event
                         .with_patient
                         .limit(6)

      CollectionPresenter.new(letters_, Renalware::Letters::LetterPresenterFactory)
    end

    private

    def pathology_descriptions_for_codes(codes)
      if codes.nil?
        Pathology::RelevantObservationDescription.all
      else
        Pathology::ObservationDescription.for(Array(codes))
      end
    end

    def pathology_patient
      Renalware::Pathology.cast_patient(patient)
    end

    # def pathology_table_view
    #   Pathology::HistoricalObservationResults::HTMLTableView.new(view_context)
    # end

    def execute_prescriptions_query(relation)
      query = Medications::PrescriptionsQuery.new(relation: relation)
      query.call
           .with_created_by
           .with_medication_route
           .with_drugs
           .with_classifications
           .with_termination
           .eager_load(drug: [:drug_types])
           .map { |prescrip| Medications::PrescriptionPresenter.new(prescrip) }
    end
  end
end
