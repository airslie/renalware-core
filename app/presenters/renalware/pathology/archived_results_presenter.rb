require_dependency "renalware/pathology"
require "hash_collection"

module Renalware
  module Pathology
    class ArchivedResultsPresenter
      attr_reader :limit

      def initialize(observations, observation_descriptions, limit)
        @observations = observations
        @observation_descriptions = observation_descriptions
        @limit = limit
      end

      # @return [HashCollection] an array of hashes representing observation results
      #                          by date
      #
      # Example:
      #
      #     [
      #       {"year"=>"2009", "date"=>"13/11", ObservationDescription.new(code: "HB") =>"2", ObservationDescription.new(code: "AL")=>"", ObservationDescription.new(code: "RBC")=>""},
      #       {"year"=>"2009", "date"=>"12/11", ObservationDescription.new(code: "HB") =>"",  ObservationDescription.new(code: "AL")=>"", ObservationDescription.new(code: "RBC")=>"3"},
      #       {"year"=>"2009", "date"=>"11/11", ObservationDescription.new(code: "HB") =>"",  ObservationDescription.new(code: "AL")=>"", ObservationDescription.new(code: "RBC")=>"4"}
      #     ]
      def rows
        @rows ||= HashCollection.new(build_rows)
      end

      def to_a
        rows.to_a
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
        # {"year"=>"2009", "date"=>"11/11", ObservationDescription.new(code: "HB") =>"", ObservationDescription.new(code: "HB")=>"", ObservationDescription.new(code: "RBC")=>"4"}
        #
        def call
          attrs = build_date_header

          @descriptions.each_with_object(attrs) do |description|
            result = find_observation_result_by_description(description)
            attrs[HeaderPresenter.new(description)] = result
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
            HeaderPresenter.new("year") => @observed_on.year.to_s,
            HeaderPresenter.new("date") => "#{@observed_on.day}/#{@observed_on.month}"
          }
        end

        # @param  [ObservationDescription]
        # @return [String] representing the observation result for the ObservationDescription,
        #                  if none is found, a blank string is returned.
        #
        def find_observation_result_by_description(description)
          observation = @observations.detect do |observation|
            observation.description == description
          end
          observation.try!(:result).to_s
        end
      end

      # Responsible for decorating header items with presentation methods
      #
      class HeaderPresenter < SimpleDelegator
        def title
           to_s
        end

        def html_class
          to_s.downcase
        end

        # Overriding specifically for hash lookup
        #
        def eql?(other)
          to_s == other.to_s
        end
      end

      class ObservationDescriptionHeaderPresenter < HeaderPresenter
        def title
          name
        end
      end
    end
  end
end
