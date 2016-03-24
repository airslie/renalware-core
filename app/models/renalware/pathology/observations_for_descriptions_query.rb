require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsForDescriptionsQuery
      def initialize(relation: Observation, descriptions:)
        @relation = relation
        @descriptions = descriptions
      end

      def call
        @relation
          .joins(:description)
          .where(description: @descriptions)
      end
    end
  end
end
