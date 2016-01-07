module Renalware
  module PRDDescriptions
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
              label: description.to_s
            }
          end
      end

      private

      def search
        @search ||= PRDDescription.search(term_or_code_cont: term).tap do |s|
          s.sorts = ["term"]
        end
      end

      def fields
        %i(id code term)
      end
    end
  end
end
