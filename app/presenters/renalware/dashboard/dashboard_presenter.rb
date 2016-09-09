require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardPresenter
      def initialize(user)
        @user = user
        @bookmarker = Patients.cast_user(user)
        @typists = Letters.cast_typist(user)
        @author = Letters.cast_author(user)
      end

      attr_reader :user

      def title
        I18n.t("renalware.dashboard.dashboards.title", name: @user.username)
      end

      def bookmarks
        @bookmarks ||= @bookmarker.bookmarks
      end

      def draft_letters
        @draft ||= present_letters(@typists.letters.draft.reverse)
      end

      def letters_pending_review
        @pending_review ||= present_letters(@author.letters.pending_review.reverse)
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
