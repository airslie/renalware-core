require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Reponsible for building the view model for historical observation results.
    #
    class HistoricalObservationResults::Presenter < ResultsPresenter
      # @return [Array] see example below for composition of array
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
      def present(*args)
        super
      end

      private

      # @section header

      def build_header
        presentation = []
        presentation << [build_date_cell, *build_descriptions]
      end

      def build_date_cell
        HeaderPresenter.new("date")
      end

      def build_descriptions
        @results.observation_descriptions.map {|description| HeaderPresenter.new(d) }
      end

      # @section body

      def build_body
        @results.map { |observations_by_date| build_row(observations_by_date) }
      end

      def build_row(observations_by_date)
        observed_on = build_date(observations_by_date)
        observations = build_observations(observations_by_date)

        [observed_on, *observations]
      end

      def build_date(observations_by_date)
        observed_on = observations_by_date.keys.first
        DatePresenter.new(observed_on)
      end

      def build_observations(observations_by_date)
        observations = observations_by_date.values.first
        observations.map { |observation| ObservationPresenter.new(observation) }
      end

      # @section presenters

      class HeaderPresenter < SimpleDelegator
        def title
           to_s
        end

        def html_class
          to_s.downcase
        end
      end

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
