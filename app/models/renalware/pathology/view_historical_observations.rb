require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewHistoricalObservations
      def initialize(
            patient,
            descriptions: default_descriptions,
            observations: Observation.all,
            limit: 20
        )

        @patient = patient
        @descriptions = default_descriptions
        @observations = default_observations.merge(observations)
        @limit = limit
      end

      def call
        observations_for_descriptions = find_observations_for_descriptions
        results = build_results(observations_for_descriptions)
        present(results)
      end

      private

      def find_observations_for_descriptions
        ObservationsForDescriptionsQuery.new(
          relation: @observations,
          descriptions: @descriptions
        ).call
      end

      def build_results(observations)
        Results.new(observations, @descriptions)
      end

      def present(results_archive)
        HistoricalResultsPresenter.new(results_archive, @limit)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end

      def default_observations
        @patient.observations.ordered
      end
    end
  end
end
