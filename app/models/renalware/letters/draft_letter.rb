require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      include Wisper::Publisher

      def self.build
        self.new
      end

      def call(patient, params={})
        letter = LetterFactory.new(patient).build(params)
        letter.save!
        broadcast(:draft_letter_successful, letter)
      rescue ActiveRecord::RecordInvalid
        broadcast(:draft_letter_failed, letter)
      end
    end
  end
end

