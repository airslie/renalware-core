module Renalware
  module Letters
    class RefreshLetter
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call
        refresh_recipient
      end

      private

      def refresh_recipient
        RefreshRecipient.new(letter.recipient).call
      end
    end
  end
end