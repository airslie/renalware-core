require "attr_extras"
require_dependency "renalware/pathology"

# Uses Rails 5 `render anywhere` feature.
module Renalware
  module Pathology
    class ObservationsDiff
      def initialize(patient:, between_dates:, descriptions:)
        @patient = patient
        @descriptions = descriptions
        @between_dates = Array(between_dates)
        if between_dates.length != 2
          raise ArgumentError, "between_dates argument must be an array of 2 dates"
        end
      end

      def to_html
        render
      end

      def to_h
        @to_h ||= build_diff_hash
      end

      private

      attr_reader :patient, :between_dates, :descriptions

      def render
        renderer.render(
          partial: "renalware/pathology/observations/diff",
          locals: {
            patient: patient,
            diffs: to_h
          }
        )
      end

      def renderer
        ApplicationController.renderer
      end

      def observations1
        @observations1 ||= begin
          observations_in_daterange(Time.zone.at(1)..between_dates.first)
        end
      end

      def observations2
        @observations2 ||= begin
          obs1_ids = observations1.map(&:id)
          observations_in_daterange(between_dates.first..between_dates.last)
            .reject{ |obs| obs1_ids.include?(obs.id) }
        end
      end

      def observations_in_daterange(range)
        Pathology::CurrentObservationsForDescriptionsQuery.new(
          patient: patient,
          descriptions: descriptions
        ).call.where(observed_at: range).reject{ |obs| obs.id.nil? }.to_a
      end

      class ObsWithDiff
        include Virtus.model
        attribute :observed_at
        attribute :result, Float
        attribute :result_diff

        def result_diff(more_recent)
          more_recent && result && (result.to_f - more_recent.result&.to_f)
        end
      end

      # Build
      # [
      #   { "HGB" => [
      #       { observed_at:, value: },
      #       { observed_at:, value:, diff: }
      #     ]
      #   }
      # ]
      # Note this could be done with a SQL window function
      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def build_diff_hash
        result = {}

        observations1.each do |older_obs|
          result[older_obs.description.code] = [
            ObsWithDiff.new(older_obs.attributes.symbolize_keys),
            nil
          ]
        end

        observations2.each do |newer_obs|
          arr = result[newer_obs.description.code] || Array(2)
          older_obs = arr[0]
          args = newer_obs.attributes.symbolize_keys
                                     .merge(result_diff: older_obs&.result_diff(newer_obs))
          arr[1] = ObsWithDiff.new(args)
        end

        result
      end
      # rubocop:enable Metrics/MethodLength Metrics/AbcSize
      # rubocop:enable Metrics/AbcSize
    end
  end
end
