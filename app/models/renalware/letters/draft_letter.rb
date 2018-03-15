# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher
      include LetterPathology

      def self.build
        new
      end

      def call(patient, params = {})
        letter = LetterFactory.new(patient, params).build
        letter.pathology_snapshot = build_pathology_snapshot(patient)
        letter.save!
        letter.reload
        broadcast(:draft_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end
    end
  end
end
