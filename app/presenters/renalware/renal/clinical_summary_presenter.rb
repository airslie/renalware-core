require_dependency "renalware/renal"
require "collection_presenter"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      MAX_EVENTS_TO_DISPLAY = 10

      def initialize(patient)
        @patient = patient
      end

      def current_prescriptions
        @current_prescriptions ||= begin
          prescriptions = @patient.prescriptions
                                  .includes(drug: [:drug_types])
                                  .includes(:medication_route)
                                  .current
                                  .ordered
          CollectionPresenter.new(prescriptions, Medications::PrescriptionPresenter)
        end
      end

      def current_problems
        @current_problems ||= @patient.problems
                                      .current
                                      .with_patient
                                      .ordered
      end

      def current_events
        @current_events ||= Events::Event.includes([:created_by, :event_type])
                                         .for_patient(@patient)
                                         .limit(MAX_EVENTS_TO_DISPLAY)
                                         .ordered
      end

      def letters
        present_letters(find_letters)
      end

      private

      def find_letters
        patient = Renalware::Letters.cast_patient(@patient)
        patient.letters
               .with_main_recipient
               .with_letterhead
               .with_author
               .with_patient
               .limit(10)
               .order(issued_on: :desc)
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Renalware::Letters::LetterPresenterFactory)
      end
    end
  end
end
