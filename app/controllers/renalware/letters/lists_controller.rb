require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      include Renalware::Concerns::Pageable

      before_action :prepare_paging, only: :show

      def show
        query = LetterQuery.new(q: params[:q])
        collection = call_query(query).page(@page).per(@per_page)
        @letters = present_letters(collection)
        authorize @letters

        @authors = User.author.ordered

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
