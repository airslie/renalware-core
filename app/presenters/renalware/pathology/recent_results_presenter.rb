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
        @rows ||= build_header + build_body
      end

      def to_a
        rows.to_a
      end

      private

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

      # Responsible for decorating header items with presentation methods
      #
      class HeaderPresenter < SimpleDelegator
        def title
           to_s
        end

        def html_class
          ""
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

        def html_class
          description.to_s.downcase
        end
      end

      # Responsible for decorating dates with presentation methods
      #
      class DatePresenter < HeaderPresenter
        def html_class
          "date"
        end
      end

      # Reponsible for decorating observations
      #
      class ObservationPresenter < HeaderPresenter
        def html_class
          description.to_s.downcase
        end
      end
    end
  end
end
