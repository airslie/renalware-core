require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      include Renalware::Concerns::Pageable

      def show
        query = LetterQuery.new(q: params[:q])
        collection = call_query(query).page(page).per(per_page)
        @letters = present_letters(collection)
        authorize @letters

        @q = query.search

        @authors = User.author.ordered
        @typists = User.ordered
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
          .with_created_by
      end
    end
  end
end
