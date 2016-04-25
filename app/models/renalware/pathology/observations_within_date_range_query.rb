require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding the most recent observations results
    # with in a specified date range.
    #
    class ObservationsWithinDateRangeQuery
      def initialize(relation: Observation, date_range:)
        @relation = relation
        @date_range = date_range
      end

      def call
        @relation.where(observed_at: @date_range)
      end
    end
  end
end
