require_dependency "renalware/dashboard"
require_dependency "collection_presenter"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @user = user
      end

      attr_reader :user

      def title
        I18n.t("renalware.dashboard.dashboards.title", name: @user.username&.capitalize)
      end

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
          receipts = Messaging.cast_recipient(user).receipts.unread
          CollectionPresenter.new(receipts, Messaging::ReceiptPresenter)
        end
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
