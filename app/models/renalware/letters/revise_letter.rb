require_dependency "renalware/letters"

module Renalware
  module Letters
    class ReviseLetter
      include Wisper::Publisher

      def self.build
        self.new
      end

      def call(patient, letter_id, params = {})
        letter = patient.letters.pending.find(letter_id)
        Letter.transaction do
          letter.revise(params)
          letter.save!
        end
        broadcast(:revise_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:revise_letter_failed, letter)
      end
    end
  end
end
