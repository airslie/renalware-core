require_dependency "renalware/renal"
require "collection_presenter"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      attr_reader :patient
      delegate :nhs_number, to: :patient, prefix: true

      def initialize(patient)
        @patient = patient
      end

      def current_prescriptions
        @current_prescriptions ||= begin
          prescriptions = @patient.prescriptions
                                  .includes(drug: [:drug_types, :classifications])
                                  .includes(:medication_route)
                                  .current
                                  .ordered
          CollectionPresenter.new(prescriptions, Medications::PrescriptionPresenter)
        end
      end

      def current_problems
        @current_problems ||= @patient.problems
                                      .current
                                      .ordered
      end

      def current_events
        @current_events ||= begin
          Events::Event.includes([:created_by, :event_type])
                       .for_patient(@patient)
                       .limit(Renalware.config.clinical_summary_max_events_to_display)
                       .ordered
        end
      end

      def current_events_count
        title_friendly_collection_count(
          actual: current_events.size,
          total: patient.summary.events_count
        )
      end

      def letters
        present_letters(find_letters)
      end

      def letters_count
        title_friendly_collection_count(
          actual: letters.size,
          total: patient.summary.letters_count
        )
      end

      def admissions
        @admissions ||= begin
          CollectionPresenter.new(
            Admissions::Admission.where(patient: patient).limit(5),
            Renalware::Admissions::AdmissionPresenter
          )
        end
      end

      def admissions_count
        title_friendly_collection_count(
          actual: admissions.size,
          total: Admissions::Admission.where(patient: patient).count
        )
      end

      private

      # Returns e.g. "9" or "10 of 11"
      def title_friendly_collection_count(actual:, total:)
        if total > actual
          "#{actual} of #{total}"
        else
          actual
        end
      end

      def find_letters
        patient = Renalware::Letters.cast_patient(@patient)
        patient.letters
               .with_main_recipient
               .with_letterhead
               .with_author
               .with_patient
               .limit(Renalware.config.clinical_summary_max_letters_to_display)
               .order(issued_on: :desc)
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Renalware::Letters::LetterPresenterFactory)
      end
    end
  end
end
