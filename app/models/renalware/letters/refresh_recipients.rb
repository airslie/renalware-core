module Renalware
  module Letters
    class RefreshRecipients
      def self.build
        self.new
      end

      def call(letter)
        letter.recipients.each do |recipient|
          RefreshRecipient.new.call(recipient)
        end
      end
    end
  end
end