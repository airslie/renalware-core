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
        @sessions = sessions
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
        selector = ->(session) { session.document && session.document.dialysis.fluid_removed }
        MeanValueStrategy.call(sessions: sessions, selector: selector)
      end

      def mean_weight_loss
        selector = ->(session) do
          if (doc = session.document)
            doc.observations_before.weight - doc.observations_after.weight
          end
        end
        MeanValueStrategy.call(sessions: sessions, selector: selector)
      end

      def mean_machine_ktv
        selector = ->(session) { session.document && session.document.dialysis.machine_ktv }
        MeanValueStrategy.call(sessions: sessions, selector: selector)
      end

      def mean_blood_flow
        selector = ->(session) { session.document && session.document.dialysis.blood_flow }
        MeanValueStrategy.call(sessions: sessions, selector: selector)
      end

      def mean_litres_processed
        selector = ->(session) { session.document && session.document.dialysis.litres_processed }
        MeanValueStrategy.call(sessions: sessions, selector: selector)
      end

      class MeanValueStrategy
        def self.call(sessions:, selector:)
          values = sessions.map { |session| selector.call(session) }
          values = exclude_nil_values(values)
          return 0 if values.blank?
          total = values.inject(0){ |sum,x| sum + x }
          mean = total.to_f / values.count.to_f
          mean.round(2)
        end

        def self.exclude_nil_values(array)
          array && array.compact
        end
      end

      private

      def all_blood_pressure_measurements
        before = sessions.map { |session| session.document.observations_before.blood_pressure }
        after = sessions.map { |session| session.document.observations_after.blood_pressure }
        [before, after].flatten
      end

      def mean_blood_pressure(observation, measurement, strategy = MeanValueStrategy)
        selector = ->(session) do
          if session.document
            session
              .document
              .public_send(observation)
              .blood_pressure
              .public_send(measurement)
          end
        end
        strategy.call(sessions: sessions, selector: selector)
      end
    end
  end
end
