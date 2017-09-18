require_dependency "renalware/messaging"

# A Receipt is cross reference between Message and Recipient.
# We can for instance mark on a receipt if/when it was read or viewed.
module Renalware
  module Messaging
    module Internal
      class ReceiptsController < BaseController
        include Renalware::Concerns::Pageable
        include PresenterHelper

        # GET aka inbox
        def unread
          render_receipts(receipts.unread)
        end

        # GET all read messages
        def read
          render_receipts(receipts.read)
        end

        def sent
          render_receipts(sent_receipts)
        end

        # PATCH
        def mark_as_read
          authorize receipt
          receipt.update(read_at: Time.zone.now)
          render locals: {
            receipt: ReceiptPresenter.new(receipt)
          }
        end

        private

        def render_receipts(receipts)
          patient_filter = Patients::SearchFilter.new(search_term, request)
          receipts = receipts.joins(message: [:patient])
          receipts = patient_filter.call(receipts).ordered.page(page).per(per_page)
          authorize receipts

          render locals: {
            receipts: present(receipts, ReceiptPresenter),
            search_form: patient_filter.search_form
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
          Messaging::Internal.cast_recipient(current_user)
        end

        def search_term
          params.fetch(:patient_search, {}).fetch(:term, nil)
        end

        def sent_receipts
          Receipt.sent_by(current_user.id)
        end
      end
    end
  end
end
