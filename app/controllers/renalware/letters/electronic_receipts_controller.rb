require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class ElectronicReceiptsController < BaseController
      include Renalware::Concerns::Pageable

      # PATCH
      def mark_as_read
        authorize receipt
        receipt.update(read_at: Time.zone.now)
        render locals: {
          receipt: ElectronicReceiptPresenter.new(receipt),
          layout: false
        }
      end

      # GET all unread electronic ccs
      def unread
        render_receipts(received_receipts.unread)
      end

      # GET all read electronic ccs
      def read
        render_receipts(received_receipts.read)
      end

      def sent
        render_receipts(sent_receipts)
      end

      private

      def render_receipts(receipts)
        authorize receipts
        render locals: {
          receipts: present_receipts(receipts)
        }
      end

      def receipt
        ElectronicReceipt.find_by!(letter_id: params[:letter_id], id: params[:id])
      end

      def received_receipts
        ElectronicReceipt.where(recipient_id: current_user.id).ordered.page(page).per(per_page)
      end

      def sent_receipts
        ElectronicReceipt.sent_by(current_user.id).ordered.page(page).per(per_page)
      end

      def present_receipts(receipts)
        CollectionPresenter.new(receipts, ElectronicReceiptPresenter)
      end
    end
  end
end
