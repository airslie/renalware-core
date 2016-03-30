require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewHistoricalObservations
      def initialize(patient, descriptions: RelevantObservationDescription.all, limit: 20)
        @patient = patient
        @descriptions = descriptions
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
          relation: @patient.observations.ordered,
          descriptions: @descriptions
        ).call
      end

      def build_results(observations)
        HistoricalResults.new(observations, @descriptions)
      end

      def present(results_archive)
        HistoricalResultsPresenter.new(results_archive, @limit)
      end
    end
  end
end
