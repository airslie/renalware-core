require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      def show
        query = LetterQuery.new(q: params[:q])
        @letters = present_letters(query.call.page(params[:page]).per(15))
        authorize @letters

        @q = query.search
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, LetterPresenterFactory)
      end
    end
  end
end
