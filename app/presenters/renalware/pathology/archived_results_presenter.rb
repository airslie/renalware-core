require_dependency "renalware/pathology"
require 'hash_collection'

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      def initialize(observations, observation_descriptions)
        @observations = observations
        @observation_descriptions = observation_descriptions
      end

      # @return [HashCollection] an array of hashes representing observation results
      #                          by date
      #
      # Example:
      #
      #     [
      #       {"year"=>"2009", "date"=>"13/11", "WBC"=>"",     "HB"=>"2.00", "AL"=>"", "RBC"=>""},
      #       {"year"=>"2009", "date"=>"12/11", "WBC"=>"5.09", "HB"=>"",     "AL"=>"", "RBC"=>"3.00"},
      #       {"year"=>"2009", "date"=>"11/11", "WBC"=>"6.09", "HB"=>"",     "AL"=>"", "RBC"=>"4.00"}
      #     ]
      def rows
        @rows ||= HashCollection.new(build_rows)
      end

      private

      def build_rows
        observations_by_date.map do |observed_on, observations_of_the_same_date|
          build_row(observed_on, observations_of_the_same_date, @observation_descriptions)
        end
      end

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

        # @return [Hash] representing observation result for a specific date
        #
        # Example:
        #
        #     {"year"=>"2009", "date"=>"13/11", "WBC"=>"", "HB"=>"2.00", "AL"=>"", "RBC"=>""}
        #
        def call
          attrs = build_date_header

          @descriptions.each_with_object(attrs) do |description|
            result = find_observation_result_by_description(description)
            attrs[description.code] = result
          end
        end

        private

        # @return [Hash] a hash representing the date observations were recorded
        #
        # Example:
        #
        #     {"year"=>"2009", "date"=>"13/11"}
        #
        def build_date_header
          {
            "year" => @observed_on.year.to_s,
            "date" => "#{@observed_on.day}/#{@observed_on.month}"
          }
        end

        # @param  [ObservationDescription]
        # @return [String] representing the observation result for the ObservationDescription,
        #                  if none is found, a blank string is returned.
        #
        def find_observation_result_by_description(description)
          observation = @observations.detect { |observation| observation.description == description }
          observation.try!(:result).to_s
        end
      end
    end
  end
end
