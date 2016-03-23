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
        observed_at_date_range = determine_date_range_for_observations
        observations = find_observations_within_date_range(observed_at_date_range)
        descriptions = find_observation_descriptions
        presenter = present_observations(observations, descriptions)
      end

      private

      def determine_date_range_for_observations
        DetermineDateRangeQuery.new(patient: @patient, limit: @limit).call
      end

      def find_observations_within_date_range(date_range)
        ObservationsWithinDateRangeQuery.new(patient: @patient, date_range: date_range).call
      end

      def find_observation_descriptions
        ObservationDescription.for(@description_codes)
      end

      def present_observations(observations, descriptions)
        ArchivedResultsPresenter.new(observations, descriptions, @limit)
      end
    end
  end
end
