require_dependency "renalware/letters"

module Renalware
  module Letters
    module LetterPathology
      extend ActiveSupport::Concern

      # Update a letter's pathology snapshot to the current point in time
      def build_pathology_snapshot(patient, letter)
        return if patient.current_observation_set.nil?
        possible_letter_codes = Renalware::Letters::RelevantObservationDescription.all.map(&:code)
        letter.pathology_snapshot = begin
          patient.current_observation_set.values.select do |code, _|
            possible_letter_codes.include?(code.to_s)
          end
        end
      end
    end
  end
end
