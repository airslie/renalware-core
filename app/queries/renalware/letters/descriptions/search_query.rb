module Renalware
  module Letters
    module Descriptions
      class SearchQuery
        attr_reader :term, :page, :per_page

        def initialize(term:, page: 1, per_page: 20)
          @term = term
          @page = page
          @per_page = per_page
        end

        def call
          search.result.page(page).per(per_page)
            .select(fields)
            .map do |description|
              {
                id: description.id,
                label: description.text
              }
            end
        end

        private

        def search
          @search ||= Description.search(text_cont: term).tap do |s|
            s.sorts = ["text"]
          end
        end

        def fields
          %i(id text)
        end
      end
    end
  end
end