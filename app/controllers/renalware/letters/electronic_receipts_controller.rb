require_dependency "renalware/letters"

module Renalware
  module Letters
    class ElectronicReceiptsController < BaseController
      # PATCH
      def mark_as_read
        authorize receipt
        receipt.update(read_at: Time.zone.now)
        render locals: {
          receipt: ElectronicReceiptPresenter.new(receipt),
          layout: false
        }
      end

      def receipt
        ElectronicReceipt.find_by!(letter_id: params[:letter_id], id: params[:id])
      end
    end
  end
end
