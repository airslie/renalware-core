require_dependency "renalware/hd"
require "document/base"

#
# This class helps us to generate statistical data from a supplied array of HD Sessions.
#
module Renalware
  module HD
    class SessionStatistics
      attr_accessor :sessions

      def initialize(sessions)
        @sessions = Array(sessions)
      end

      def dialysis_time_shortfall
        100
      end

      def number_of_missed_sessions
        sessions.count{ |session| session.is_a?(Session::DNA) }
      end

      def pre_mean_systolic_blood_pressure
        mean_blood_pressure(:observations_before, :systolic)
      end

      def pre_mean_diastolic_blood_pressure
        mean_blood_pressure(:observations_before, :diastolic)
      end

      def post_mean_systolic_blood_pressure
        mean_blood_pressure(:observations_after, :systolic)
      end

      def post_mean_diastolic_blood_pressure
        mean_blood_pressure(:observations_after, :diastolic)
      end

      def lowest_systolic_blood_pressure
        all_blood_pressure_measurements.min_by(&:systolic)
      end

      def highest_systolic_blood_pressure
        all_blood_pressure_measurements.max_by(&:systolic)
      end

      def mean_fluid_removal
        selector = ->(session) { session.document.dialysis.fluid_removed }
        MeanValueStrategy.new(sessions: sessions, selector: selector).call
      end

      def mean_weight_loss
        selector = ->(session) do
          if (doc = session.document)
            doc.observations_before.weight - doc.observations_after.weight
          end
        end
        MeanValueStrategy.new(sessions: sessions, selector: selector).call
      end

      def mean_machine_ktv
        selector = ->(session) {session.document.dialysis.machine_ktv }
        MeanValueStrategy.new(sessions: sessions, selector: selector).call
      end

      def mean_blood_flow
        selector = ->(session) { session.document.dialysis.blood_flow }
        MeanValueStrategy.new(sessions: sessions, selector: selector).call
      end

      def mean_litres_processed
        selector = ->(session) { session.document.dialysis.litres_processed }
        MeanValueStrategy.new(sessions: sessions, selector: selector).call
      end

      private

      class MeanValueStrategy
        def initialize(sessions:, selector:)
          @sessions = sessions
          @selector = selector
        end

        def call
          return 0 if values.blank?
          mean
        end

        def values
          @values ||= begin
            sessions.map { |session| selector.call(session) }.compact
          end
        end

        def total
          @total ||= values.inject(0){ |sum, value| sum + value }
        end

        def mean
          (total.to_f / values.count.to_f).round(2)
        end

        private
        attr_reader :sessions, :selector
      end

      def all_blood_pressure_measurements
        before = sessions.map { |session| session.document.observations_before.blood_pressure }
        after = sessions.map { |session| session.document.observations_after.blood_pressure }
        [before, after].flatten
      end

      def mean_blood_pressure(observation, measurement, strategy = MeanValueStrategy)
        selector = ->(session) do
          session
            .document
            .public_send(observation)
            .blood_pressure
            .public_send(measurement)
        end
        strategy.new(sessions: sessions, selector: selector).call
      end
    end
  end
end
