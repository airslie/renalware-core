require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Results
      def initialize(observations, observation_descriptions)
        @observations = observations
        @observation_descriptions = observation_descriptions
      end

      def to_a
        observations_by_date.map do |observed_on, observations_of_the_same_date|
          build_row(observed_on, observations_of_the_same_date, @observation_descriptions)
        end
      end

      private

      def observations_by_date
        @observations.group_by { |observation| observation.observed_at.to_date }
      end

      def build_row(observed_on, observations, descriptions)
        RowBuilder.new(observed_on, observations, descriptions).call
      end

      # Responsible for building a row of observation results for a specific
      # date.
      #
      class RowBuilder
        def initialize(observed_on, observations, descriptions)
          @observed_on = observed_on
          @observations = observations
          @descriptions = descriptions
        end

        # @return [Hash] representing a collection of observations results for a specific date
        #
        # Example:
        #
        # {Date.parse("2016-10-10") => {ObservationDescription.new(code: "HB") =>"",
        #   ObservationDescription.new(code: "RBC")=>"4"}}
        #
        def call
          descriptions = @descriptions.each_with_object({}) do |description, attrs|
            attrs[description] = find_observation_result_by_description(description)
          end

          { @observed_on => descriptions }
        end

        private

        # @param  [ObservationDescription]
        # @return [Observation] representing the observation result for the ObservationDescription,
        #                       if none is found, a nil returned.
        #
        def find_observation_result_by_description(description)
          observation = @observations.detect { |o| o.description == description }
          observation.try!(:result)
        end
      end
    end
  end
end
