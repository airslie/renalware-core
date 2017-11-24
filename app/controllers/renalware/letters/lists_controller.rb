require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      include Renalware::Concerns::Pageable

      def show
        query = LetterQuery.new(q: params[:q])
        letters = find_and_authorize_letters(query)

        render locals: {
          letters: letters,
          authors: User.author.ordered,
          typists: User.ordered,
          q: query.search
        }
      end

      private

      def find_and_authorize_letters(query)
        collection = call_query(query).page(page).per(per_page)
        present_letters(collection).tap { |letters| authorize letters }
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
