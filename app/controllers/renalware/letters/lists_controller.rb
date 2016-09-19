require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      def show
        query = LetterQuery.new(q: params[:q])
        collection = call_query(query).page(params[:page]).per(15)
        @letters = present_letters(collection)
        authorize @letters

        @q = query.search
      end

      def present_letters(letters)
        CollectionPresenter.new(letters, LetterPresenterFactory)
      end

      def call_query(query)
        query
          .call
          .with_patient
          .with_main_recipient
          .with_letterhead
          .with_author
      end
    end
  end
end
