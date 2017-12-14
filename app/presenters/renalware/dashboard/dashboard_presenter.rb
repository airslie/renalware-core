require_dependency "renalware/dashboard"
require_dependency "collection_presenter"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @user = user
      end

      attr_reader :user

      def bookmarks
        @bookmarks ||= begin
          Patients.cast_user(user)
                  .bookmarks
                  .ordered
                  .includes(patient: [current_modality: :description])
        end
      end

      def letters_in_progress
        @letters_in_progress ||= begin
          present_letters(
            Letters.cast_author(user).letters.in_progress.reverse
          )
        end
      end

      def unread_messages_receipts
        @unread_messages_receipts ||= begin
          receipts = Messaging::Internal.cast_recipient(user).receipts.unread
          CollectionPresenter.new(receipts, Messaging::Internal::ReceiptPresenter)
        end
      end

      def unread_electronic_ccs
        @unread_electronic_ccs ||= begin
          receipts = Letters::ElectronicReceipt.unread.for_recipient(user.id).ordered
          CollectionPresenter.new(receipts, Letters::ElectronicReceiptPresenter)
        end
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
