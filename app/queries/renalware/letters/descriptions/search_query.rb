module Renalware
  module Letters
    module Descriptions
      class SearchQuery
        attr_reader :term, :page, :per_page

        def initialize(term)
          @search_params = { q: { text_cont: term } }
          @search_params.reverse_merge!(s: "text asc")
        end

        def call
          search.result
        end

        def search
          @search ||= Description.search(@search_params)
        end
      end
    end
  end
end
