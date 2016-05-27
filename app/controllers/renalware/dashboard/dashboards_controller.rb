require_dependency "renalware/dashboard"

module Renalware
  module Dashboard
    class DashboardsController < BaseController
      skip_after_action :verify_authorized

      def show
        letters = find_letters
        render :show, locals: { user: current_user, letters: present_letters(letters) }
      end

      private

      def find_letters
        author.letters.pending.reverse
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, Letters::LetterPresenterFactory)
      end

      def author
        Letters.cast_author(current_user)
      end
    end
  end
end
