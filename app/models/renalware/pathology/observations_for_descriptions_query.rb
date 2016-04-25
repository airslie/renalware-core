require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for finding Observations for the specified descriptions.
    #
    class ObservationsForDescriptionsQuery
      def initialize(relation: Observation.all, descriptions: ObservationDescription.all)
        @relation = relation
        @descriptions = descriptions
      end

      def call
        @relation
          .joins(:description)
          .preload(:description)
          .where(description: @descriptions)
      end
    end
  end
end
