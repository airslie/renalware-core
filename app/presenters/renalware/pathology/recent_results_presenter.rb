require_dependency "renalware/pathology"
require "hash_collection"

module Renalware
  module Pathology
    class RecentResultsPresenter
      attr_reader :limit

      def initialize(results, limit)
        @results = results
        @limit = limit
      end

      # @return [HashCollection] an array of hashes representing observation results
      #                          by date
      #
      # Example:
      #
      #     [
      #       {"year"=>"2009", "date"=>"13/11", ObservationDescription.new(code: "HB") =>"2",
      #         ObservationDescription.new(code: "AL")=>""},
      #       {"year"=>"2009", "date"=>"12/11", ObservationDescription.new(code: "HB") =>"",
      #         ObservationDescription.new(code: "AL")=>""},
      #       {"year"=>"2009", "date"=>"11/11", ObservationDescription.new(code: "HB") =>"",
      #         ObservationDescription.new(code: "AL")=>""}
      #     ]
      #
      def rows
        @rows ||= HashCollection.new(present_results(@results.to_a))
      end

      def to_a
        rows.to_a
      end

      private

      def present_results(results_archive)
        results_archive.map do |results|
          observed_on, observations_by_description = results.keys.first, results.values.first

          presented_dates = present_dates(observed_on)
          presented_observations = present_observations(observations_by_description)
          presented_dates.merge(presented_observations)
        end
      end

      # @param  [Date] a date representing the date the observation was observed on
      # @return [Hash] a hash representing the date observations were recorded
      #                with keys decorated with HeadPresenter
      #
      # Example:
      #
      #     {"year"=>"2009", "date"=>"13/11"}
      #
      def present_dates(observed_on)
        {
          HeaderPresenter.new("year") => observed_on.year.to_s,
          HeaderPresenter.new("date") => "#{observed_on.day}/#{observed_on.month}"
        }
      end

      # @param  [Hash] a hash containing the observations keyed by observation description
      # @return [Hash] returns the hash with the keys decorated with
      #                ObservationDescriptionHeaderPresenter
      #
      def present_observations(observations_by_desc)
        observations_by_desc.each_with_object({}) do |(desc, observations), memo|
          memo[ObservationDescriptionHeaderPresenter.new(desc)] = observations
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
