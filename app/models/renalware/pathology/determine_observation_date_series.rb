require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding the series of unique `observed_at` dates for an
    # Observation relation.
    #
    class DetermineObservationDateSeries
      def initialize(relation: Observation)
        @relation = relation
      end

      def call
        @relation
          .order("DATE(observed_at) DESC")
          .pluck("DISTINCT ON (DATE(observed_at)) DATE(observed_at)")
      end
    end
  end
end
