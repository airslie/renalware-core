require_dependency "renalware/messaging"

# A Receipt is cross reference between Message and Recipient.
# We can for instance mark on a receipt if/when it was read or viewed.
module Renalware
  module Messaging
    class ReceiptsController < BaseController
      include Renalware::Concerns::Pageable
      include PresenterHelper

      # GET aka inbox
      def unread
        render_receipts(receipts.unread)
      end

      # GET
      def read
        render_receipts(receipts)
      end

      # PATCH
      def mark_as_read
        authorize receipt
        receipt.update(read_at: Time.zone.now)
        render locals: {
          message: Messaging::ReceiptPresenter(receipt)
        }
      end

      private

      def render_receipts(receipts)
        authorize receipts
        render locals: {
          receipts: present(receipts, Messaging::ReceiptPresenter)
        }
      end

      def receipts
        @receipts ||= recipient.receipts.page(page).per(per_page)
      end

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
