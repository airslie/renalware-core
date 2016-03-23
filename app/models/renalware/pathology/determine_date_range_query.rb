require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding the date range of a observation relation
    # for the specified limit.
    #
    class DetermineDateRangeQuery
      attr_reader :limit

      def initialize(relation: Observation, limit:)
        @relation = relation
        @limit = limit
      end

      def call
        values = @relation
          .ordered
          .distinct(:observed_at)
          .limit(@limit)
          .pluck(:observed_at)
          .reverse

        Range.new(values.first, values.last)
      end
    end
  end
end
