require_dependency "renalware/letters"

module Renalware
  module Letters
    class ReviseLetter
      include Wisper::Publisher

      def self.build
        self.new(PersistLetter.build)
      end

      def initialize(persist_letter)
        @persist_letter = persist_letter
      end

      def call(patient, letter_id, params={})
        letter = patient.letters.find(letter_id)
        letter.attributes = params

        patient.transaction do
          @persist_letter.call(letter)
        end
        broadcast(:revise_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:revise_letter_failed, letter)
      end
    end
  end
end
