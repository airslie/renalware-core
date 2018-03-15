# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class ReviseLetter
      include Wisper::Publisher
      include LetterPathology

      def self.build
        new
      end

      def call(patient, letter_id, params = {})
        letter = patient.letters.pending.find(letter_id)
        Letter.transaction do
          letter.revise(params)
          if letter.changes.key?(:pathology_timestamp)
            letter.pathology_snapshot = build_pathology_snapshot(patient)
          end
          letter.save!
        end
        broadcast(:revise_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:revise_letter_failed, letter)
      end
    end
  end
end
