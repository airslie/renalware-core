require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher

      def self.build
        self.new(PersistLetter.build)
      end

      def initialize(persist_letter)
        @persist_letter = persist_letter
      end

      def call(patient, params={})
        letter = LetterFactory.new(patient).build(params)

        patient.transaction do
          @persist_letter.call(letter)
        end
        broadcast(:draft_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end
    end
  end
end

