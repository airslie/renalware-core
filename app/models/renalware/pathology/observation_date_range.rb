require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for converting a relation Observation to a range
    #
    class ObservationDateRange
      def initialize(relation: Observation.ordered)
        @relation = relation
      end

      def call
        build_range(@relation.pluck(:observed_at).reverse)
      end

      private

      def build_range(values)
        Range.new(values.first, values.last)
      end
    end
  end
end
