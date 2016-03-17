module Renalware
  module Letters
    class RefreshLetter
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call
        refresh_main_recipient
      end

      private

      def refresh_main_recipient
        RefreshMainRecipient.new(letter.main_recipient).call
      end
    end
  end
end