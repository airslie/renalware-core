require_dependency "renalware/dashboard"
require_dependency "collection_presenter"

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
        I18n.t("renalware.dashboard.dashboards.title", name: @user.username&.capitalize)
      end

      def bookmarks
        @bookmarks ||= @bookmarker
                         .bookmarks
                         .ordered
                         .includes(patient: [current_modality: :description])
      end

      def letters_in_progress
        @letters_in_progress ||= present_letters(@author.letters.in_progress.reverse)
      end

      private

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end
    end
  end
end
