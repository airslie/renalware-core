module Renalware
  module Letters
    class RefreshRecipients
      def self.build
        self.new(RefreshRecipient.build)
      end

      def initialize(refresh_recipient)
        @refresh_recipient = refresh_recipient
      end

      def call(letter)
        letter.recipients.each do |recipient|
          @refresh_recipient.call(recipient)
        end
      end
    end
  end
end