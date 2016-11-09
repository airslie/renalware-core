#
# Decorates an array of session objects, adding methods that provide e.g. a mean measured value
# across all HD sessions for a patient. See also AuditableSession.
#
# Example usage:
#
#  recent_sessions = RecentPatientSessions.call # => [Session::DNA, Session::Closed, ...]
#  auditable_sessions = AuditableSessionCollection.new(recent_sessions)
#  auditable_sessions.pre_mean_systolic_blood_pressure => 121
#

require_dependency "renalware/hd"

module Renalware
  module HD
    module Sessions
      class AuditableSessionCollection < SimpleDelegator
        attr_accessor :sessions

        AUDITABLE_ATTRIBUTES = %i(
          pre_mean_systolic_blood_pressure
          pre_mean_diastolic_blood_pressure
          post_mean_systolic_blood_pressure
          post_mean_diastolic_blood_pressure
          lowest_systolic_blood_pressure
          highest_systolic_blood_pressure
          mean_fluid_removal
          mean_weight_loss
          mean_machine_ktv
          mean_blood_flow
          mean_litres_processed
        ).freeze

        def to_h
          AUDITABLE_ATTRIBUTES.inject({}) do |hash, sym|
            hash[sym] = public_send(sym)
            hash
          end
        end

        def initialize(sessions)
          @sessions = Array(sessions).map do |session|
            Renalware::HD::Sessions::AuditableSession.new(session)
          end
          super(@sessions)
        end

        def number_of_missed_sessions
          sessions.count(&:dna?)
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
          all_blood_pressure_measurements.select(&:systolic).min_by(&:systolic)
        end

        def highest_systolic_blood_pressure
          all_blood_pressure_measurements.select(&:systolic).max_by(&:systolic)
        end

        def dialysis_minutes_shortfall
          sessions.sum(&:dialysis_minutes_shortfall)
        end

        def dialysis_minutes_shortfall_percentage
          selector = ->(session) { session.dialysis_minutes_shortfall_percentage }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call.round(2)
        end

        def mean_ufr
          selector = ->(session) { session.ufr }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_fluid_removal
          selector = ->(session) { session.document.dialysis.fluid_removed }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_weight_loss
          selector = ->(session) { session.weight_loss }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_weight_loss_as_percentage_of_body_weight
          selector = ->(session) { session.weight_loss_as_percentage_of_body_weight }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_machine_ktv
          selector = ->(session) { session.document.dialysis.machine_ktv }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_blood_flow
          selector = ->(session) { session.document.dialysis.blood_flow }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
        end

        def mean_litres_processed
          selector = ->(session) { session.document.dialysis.litres_processed }
          MeanValueStrategy.new(sessions: closed_sessions, selector: selector).call
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
          @closed_sessions ||= sessions.select(&:closed?)
        end

        def all_blood_pressure_measurements
          sessions.map(&:blood_pressure_measurements).flatten
        end

        # Helper to build a dynamic selector to grab the observation (pre/post) and blood pressure
        # measurement (sys/dias) and mean them.
        # Example usage:
        #   mean_blood_pressure(:observations_after, :diastolic)
        def mean_blood_pressure(observation, measurement)
          selector = ->(session) do
            session
              .document
              .public_send(observation)
              .blood_pressure
              .public_send(measurement)
          end
          MeanValueStrategy.new(sessions: sessions, selector: selector).call
        end
      end
    end
  end
end
