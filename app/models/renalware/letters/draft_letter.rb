require_dependency "renalware/letters"

module Renalware
  module Letters
    class DraftLetter
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call(attributes)
        assign_letter_attributes(attributes)
        if valid_letter?
          assign_automatic_cc_recipients
          save_letter
          refresh_dynamic_data_in_letter
        end
        letter
      end

      private

      def assign_letter_attributes(attributes)
        AssignLetterAttributes.new(letter).call(attributes)
      end

      def assign_automatic_cc_recipients
        AssignAutomaticRecipients.new(letter).call
      end

      def refresh_dynamic_data_in_letter
        RefreshLetter.new(letter).call
      end

      def valid_letter?
        letter.valid?
      end

      def save_letter
        letter.save
      end
    end
  end
end
