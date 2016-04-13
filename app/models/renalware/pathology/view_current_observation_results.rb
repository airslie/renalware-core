require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewCurrentObservationResults
      def initialize(observations, presenter, descriptions: default_descriptions)
        @observations = observations
        @descriptions = descriptions
        @presenter = presenter
      end

      def call(params={})
        results = find_current_observations_for_descriptions
        present(results)
      end

      private

      def find_current_observations_for_descriptions
        CurrentObservationsForDescriptionsQuery
          .new(relation: @observations, descriptions: @descriptions)
          .call
      end

      def present(results)
        @presenter.present(results)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end
    end
  end
end
