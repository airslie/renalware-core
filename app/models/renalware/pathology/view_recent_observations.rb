require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewRecentObservations
      def initialize(
            patient,
            descriptions: default_descriptions,
            observations: Observation.all,
            limit: 20
        )

        @patient = patient
        @descriptions = descriptions
        @observations = default_observations.merge(observations)
        @limit = limit
      end

      def call
        observations_for_descriptions = find_observations_for_descriptions
        observation_date_series = determine_observation_date_series(observations_for_descriptions)
        date_range = build_date_range(observation_date_series)
        observations = filter_observations_within_date_range(observations_for_descriptions, date_range)
        results = build_results(observations)
        present(results)
      end

      private

      def find_observations_for_descriptions
        ObservationsForDescriptionsQuery.new(
          relation: @observations,
          descriptions: @descriptions
        ).call
      end

      def determine_observation_date_series(observations)
        DetermineObservationDateSeries.new(relation: observations).call
      end

      def build_date_range(date_series)
        ObservationDateRange.build(date_series.reverse)
      end

      def filter_observations_within_date_range(observations, date_range)
        ObservationsWithinDateRangeQuery.new(relation: observations, date_range: date_range).call
      end

      def build_results(observations)
        Results.new(observations.ordered, @descriptions)
      end

      def present(results_archive)
        RecentResultsPresenter.new(results_archive, @limit)
      end

      def default_descriptions
        RelevantObservationDescription.all
      end

      def default_observations
        @patient.observations
      end
    end
  end
end
