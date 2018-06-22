# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module Letters
    class ListsController < Letters::BaseController
      include Renalware::Concerns::Pageable

      # rubocop:disable Metrics/MethodLength
      # TODO: Use a presenter here
      def show
        query = LetterQuery.new(q: params[:q])
        letters = find_and_authorize_letters(query)

        locals = {
          letters: letters,
          authors: User.author.ordered,
          typists: User.ordered,
          letterheads: Letters::Letterhead.ordered,
          q: query.search
        }
        respond_to do |format|
          format.html { render(locals: locals) }
          format.js   { render(locals: locals, layout: false) }
        end
      end
      # rubocop:enable Metrics/MethodLength

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
