require_dependency "renalware/pathology"
require "hash_collection"

module Renalware
  module Pathology
    class RecentResultsPresenter
      def self.build(results, limit, paginator)
        new(results, limit, paginator)
      end

      attr_reader :limit, :paginator

      def initialize(results, limit, paginator)
        @results = results
        @limit = limit
        @paginator = paginator
      end

      # @return [Array] see example below for composition of array
      #
      # Example:
      #
      #     [
      #       ["year", "2009", "2009"],
      #       ["date", "13/11", "12/11"],
      #       [ObservationDescription.new(code: "HGB"), Observation.new(result: "4"), Observation.new(result: nil)],
      #       [ObservationDescription.new(code: "MCV"), Observation.new(result: nil), Observation.new(result: "6")],
      #       [ObservationDescription.new(code: "WBC"), Observation.new(result: "2"), Observation.new(result: "3")],
      #     ]
      #
      def present
        @presentation ||= present_results
      end

      def to_a
        present
      end

      private

      def present_results
        build_header + build_body
      end

      # @section header

      def build_header
        presentation = []
        presentation << [HeaderPresenter.new("year"), *build_years]
        presentation << [HeaderPresenter.new("date"), *build_dates]
      end

      def build_years
        result_dates.map { |date| DatePresenter.new(date.year.to_s) }
      end

      def build_dates
        result_dates.map { |date| DatePresenter.new("#{date.day}/#{date.month}") }
      end

      def result_dates
        @results.map(&:keys).flatten
      end

      # @section body

      def build_body
        @results.observation_descriptions.map { |description| build_row(description) }
      end

      def build_row(description)
        observations = build_observations_for_description(description)
        [ObservationDescriptionHeaderPresenter.new(description), *observations]
      end

      def build_observations_for_description(description)
        @results
          .map(&:values)
          .flatten
          .select { |obs| obs.description == description }
          .map { |obs| ObservationPresenter.new(obs) }
      end

      # @section presenters

      class HeaderPresenter < SimpleDelegator
        def title
           to_s
        end

        def html_class
          ""
        end
      end

      class ObservationDescriptionHeaderPresenter < HeaderPresenter
        def title
          name
        end

        def html_class
          description.to_s.downcase
        end
      end

      class DatePresenter < HeaderPresenter
        def html_class
          "date"
        end
      end
    end
  end
end
