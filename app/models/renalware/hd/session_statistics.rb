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
        # Add helpers to each session to helps us cleanly resolve statistical data.
        @sessions.each { |session| session.extend(SessionHelpers) }
      end

      def dialysis_minutes_shortfall
        sessions.sum(&:dialysis_minutes_shortfall)
      end

      def dialysis_minutes_shortfall_percentage
        session_count = closed_sessions.count.to_f
        return 0 if session_count == 0
        percentage = closed_sessions.sum(&:dialysis_minutes_shortfall_percentage) / session_count
        percentage.round(2)
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

      class MeanValueStrategy
        def initialize(sessions:, selector:)
          @sessions = sessions
          @selector = selector
        end

        def call
          values.blank? ? 0 : mean
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

      private

      def closed_sessions
        @closed_sessions = sessions.select{ |session| session.is_a?(Session::Closed) }
      end

      def all_blood_pressure_measurements
        sessions.map(&:all_blood_pressure_measurements).flatten
      end

      module SessionHelpers
        NullHDProfile = Naught.build do |config|
          config.black_hole
          config.define_explicit_conversions
          config.singleton
        end

        def all_blood_pressure_measurements
          [
            document.observations_before.blood_pressure,
            document.observations_after.blood_pressure
          ]
        end

        def profile
          super || NullHDProfile.instance
        end

        def prescribed_time
          profile.prescribed_time.to_i
        end

        # Note the profile here might be a NullHDProfile which will always return 0 for the
        # prescribed time - so sessions with a missing profile always report a
        # dialysis_time_shortfall of 0
        def dialysis_minutes_shortfall
          prescribed_time == 0 ? 0 : prescribed_time - duration
        end

        def dialysis_minutes_shortfall_percentage
          return 0.0 if dialysis_minutes_shortfall == 0
          (dialysis_minutes_shortfall.to_f / prescribed_time.to_f) * 100.0
        end
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
