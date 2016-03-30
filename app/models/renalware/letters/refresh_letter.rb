module Renalware
  module Letters
    class RefreshLetter
      attr_reader :letter

      def initialize(letter)
        @letter = letter
      end

      def call
        refresh_main_recipient
        refresh_cc_recipients
      end

      private

      def refresh_main_recipient
        RefreshMainRecipient.new(letter.main_recipient).call
      end

      def refresh_cc_recipients
        letter.cc_recipients.each do |cc_recipient|
          RefreshCCRecipient.new(cc_recipient).call
        end
      end
    end
  end
end