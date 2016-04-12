require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewObservations
      def initialize(patient, presenter_factory:, descriptions:, limit: 20)
        @patient = patient
        @presenter_factory = presenter_factory
        @descriptions = descriptions
        @observations = default_observations
        @limit = limit
      end

      def call(params={})
        observations_for_descriptions = find_observations_for_descriptions
        observation_date_series = determine_observation_date_series(observations_for_descriptions)
        paginated_date_series = paginate(observation_date_series, params)
        date_range = build_date_range(paginated_date_series)
        observations = filter_observations_within_date_range(observations_for_descriptions, date_range)
        results = build_results(observations)
        present(results, paginated_date_series)
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

      def paginate(array, params)
        Kaminari.paginate_array(array).page(params[:page]).per(@limit)
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

      def present(results_archive, paginator)
        @presenter_factory.build(results_archive, @limit, paginator)
      end

      def default_observations
        @patient.observations
      end
    end
  end
end
