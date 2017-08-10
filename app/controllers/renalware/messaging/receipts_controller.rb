require_dependency "renalware/messaging"

# A Receipt is cross reference between Message and Recipient.
# We can for instance mark on a receipt if/when it was read or viewed.
module Renalware
  module Messaging
    class ReceiptsController < BaseController

      def mark_as_read
        authorize receipt
        receipt.update(read_at: Time.zone.now)
        render locals: { message: InternalMessagePresenter.new(receipt.message) }
      end

      private

      def receipt
        @receipt ||= recipient.receipts.find_by!(
          message_id: params[:message_id],
          id: params[:id]
        )
      end

      def recipient
        Messaging.cast_recipient(current_user)
      end
    end
  end
end
