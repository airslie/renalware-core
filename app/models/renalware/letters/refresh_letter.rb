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
        letter.main_recipient.refresh!
      end

      def refresh_cc_recipients
        letter.cc_recipients.each { |cc| cc.refresh! }
      end
    end
  end
end