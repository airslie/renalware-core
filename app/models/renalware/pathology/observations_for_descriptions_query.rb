require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ObservationsForDescriptionsQuery
      # Reponsible for finding Observations for the specified descriptions
      #
      def initialize(relation: Observation.all, descriptions: ObservationDescription.all)
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
