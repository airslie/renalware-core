require_dependency "renalware/messaging"
require "collection_presenter"

module Renalware
  module Messaging
    class ReceivedMessagesController < BaseController
      include Renalware::Concerns::Pageable

      def index
        receipts = recipient.receipts.page(page).per(per_page)
        authorize receipts

        render locals: {
          message_receipts: CollectionPresenter.new(receipts, Messaging::ReceiptPresenter)
        }
      end

      def recipient
        Messaging.cast_recipient(current_user)
      end
    end
  end
end
