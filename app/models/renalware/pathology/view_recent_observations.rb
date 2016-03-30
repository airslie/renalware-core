require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewRecentObservations
      def initialize(patient, descriptions: RelevantObservationDescription.all, limit: 20)
        @patient = patient
        @descriptions = descriptions
        @limit = limit
      end

      def call
        observations_for_descriptions = find_observations_for_descriptions
        date_range = determine_date_range_for_observations(observations_for_descriptions)
        observations = filter_observations_within_date_range(observations_for_descriptions, date_range)
        results = build_results(observations)
        present(results)
      end

      private

      def find_observations_for_descriptions
        ObservationsForDescriptionsQuery.new(
          relation: @patient.observations.ordered,
          descriptions: @descriptions
        ).call
      end

      def determine_date_range_for_observations(observations)
        observations = DetermineDateRangeQuery.new(relation: observations, limit: @limit).call
        ObservationDateRange.new(relation: observations).call
      end

      def filter_observations_within_date_range(observations, date_range)
        ObservationsWithinDateRangeQuery.new(relation: observations, date_range: date_range).call
      end

      def build_results(observations)
        RecentResults.new(observations, @descriptions)
      end

      def present(results_archive)
        RecentResultsPresenter.new(results_archive, @limit)
      end
    end
  end
end
