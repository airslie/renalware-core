module Renalware
  module Letters
    class RefreshCCRecipient
      attr_reader :cc_recipient

      def initialize(cc_recipient)
        @cc_recipient = cc_recipient
      end

      def call
        copy_source_address
      end

      private

      def copy_source_address
        if source.try(:current_address).present?
          cc_recipient.copy_address!(source.current_address)
        end
      end

      def source
        cc_recipient.source
      end
    end
  end
end