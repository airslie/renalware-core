require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(query)
        @query = query
      end

      def first
        @query.first
      end

      def to_a
        [
          {
          "observed_at"=> I18n.l(first.observed_at.to_date),
          first.description.code => first.result
          }
        ]
      end
    end
  end
end
