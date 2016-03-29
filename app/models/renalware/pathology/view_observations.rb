require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ViewObservations
      def initialize(patient, description_codes, limit: 20)
        @patient = patient
        @description_codes = description_codes
        @limit = limit
      end

      def call
        descriptions = find_observation_descriptions
        observations_for_descriptions = find_observations_for_descriptions(descriptions)
        date_range = determine_date_range_for_observations(observations_for_descriptions)
        observations = filter_observations_within_date_range(observations_for_descriptions, date_range)
        present_observations(observations, descriptions)
      end

      private

      def find_observation_descriptions
        ObservationDescription.for(@description_codes)
      end

      def find_observations_for_descriptions(descriptions)
        ObservationsForDescriptionsQuery.new(
          relation: @patient.observations.ordered,
          descriptions: descriptions
        ).call
      end

      def determine_date_range_for_observations(observations)
        observations = DetermineDateRangeQuery.new(relation: observations, limit: @limit).call
        ObservationDateRange.new(relation: observations).call
      end

      def filter_observations_within_date_range(observations, date_range)
        ObservationsWithinDateRangeQuery.new(relation: observations, date_range: date_range).call
      end

      def present_observations(observations, descriptions)
        ArchivedResultsPresenter.new(observations, descriptions, @limit)
      end
    end
  end
end
