require_dependency "renalware/pathology"
require "hash_collection"

module Renalware
  module Pathology
    class HistoricalResultsPresenter
      attr_reader :limit

      def initialize(results, limit)
        @results = results
        @limit = limit
      end

      # @return [Array] an array of observations prefixed by a header
      #                          by date
      #
      # Example:
      #
      #     [
      #       ["observed_on", "HGB", "MCV", "WBC"]
      #       [Date.parse("2011-10-10")], Observation.new(result: "2"), Observation.new(result: "3")],
      #       [Date.parse("2011-10-09")], Observation.new(result: "5"), nil],
      #       [Date.parse("2011-10-10")], nil, Observation.new(result: "4")],
      #     ]
      #
      def rows
        @rows ||= present_results(@results)
      end

      def to_a
        rows
      end

      private

      def present_results(results_archive)
        rows = @results.map do |observations_by_date|
          [I18n.l(observations_by_date.keys.first), *observations_by_date.values.first]
        end

        rows.unshift(["observed_on", *@results.observation_descriptions.map(&:code)])
      end
    end
  end
end
