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
        rows = build_body
        header = build_header
        rows.unshift(header)
      end

      def build_header
        descriptions = @results.observation_descriptions.map {|d| HeaderPresenter.new(d) }
        observed_on = HeaderPresenter.new("date")

        [observed_on, *descriptions]
      end

      def build_body
        @results.map do |observations_by_date|
          observed_on = observations_by_date.keys.first
          observations = observations_by_date.values.first

          observed_on = DatePresenter.new(observed_on)
          observations = observations.map { |o| ObservationPresenter.new(o) }


          [observed_on, *observations]
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
      end

      # Reponsible for decorating observations
      #
      class ObservationPresenter < HeaderPresenter
        def html_class
          description.to_s.downcase
        end
      end

      # Responsible for decorating dates with presentation methods
      #
      class DatePresenter < HeaderPresenter
        def to_s
          I18n.l(self)
        end

        def html_class
          "date"
        end
      end
    end
  end
end
