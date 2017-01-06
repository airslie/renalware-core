require_dependency "renalware/renal"
require "collection_presenter"

module Renalware
  module Renal
    class ClinicalSummaryPresenter
      def initialize(patient)
        @patient = patient
      end

      def current_prescriptions
        @current_prescriptions ||= begin
          prescriptions = @patient.prescriptions
                                  .current
                                  .includes([:medication_route, drug: [:drug_types]])
                                  .ordered
          CollectionPresenter.new(prescriptions, Medications::PrescriptionPresenter)
        end
      end

      def current_problems
        @current_problems ||= @patient.problems.current.ordered
      end

      def current_events
        @current_events ||= Events::Event.includes([:created_by, :event_type])
                                         .for_patient(@patient)
      end

      def letters
        present_letters(find_letters)
      end

      private

      def find_letters
        patient = Renalware::Letters.cast_patient(@patient)
        patient.letters
               .approved
               .with_main_recipient
               .with_letterhead
               .with_author
               .with_event
               .with_patient
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Renalware::Letters::LetterPresenterFactory)
      end
    end
  end
end
