require_dependency "renalware/hd"
require "document/base"

module Renalware
  module HD
    class SessionStatistics
      attr_accessor :sessions

      def initialize(sessions)
        @sessions = sessions
      end

      # def sessions
      #   @sessions ||= QueryableSession.auditable_sessions_for(patient)
      # end

      def pre_mean_systolic_blood_pressure
        blood_pressure_statistic(:observations_before, :systolic, MeanValueStrategy)
      end

      def pre_mean_diastolic_blood_pressure
        blood_pressure_statistic(:observations_before, :diastolic, MeanValueStrategy)
      end

      def post_mean_systolic_blood_pressure
        blood_pressure_statistic(:observations_after, :systolic, MeanValueStrategy)
      end

      def post_mean_diastolic_blood_pressure
        blood_pressure_statistic(:observations_after, :diastolic, MeanValueStrategy)
      end

      private

      def blood_pressure_statistic(observation, measurement, strategy)
        selector = ->(session) do
          session
            .public_send(observation)
            .blood_pressure
            .public_send(measurement)
        end
        strategy.call(sessions: sessions, selector: selector)
      end

      class MeanValueStrategy
        def self.call(sessions:, selector:)
          values = sessions.map { |session| selector.call(session) }
          return 0 if values.blank?
          total = values.inject(0){ |sum,x| sum + x }
          mean = total.to_f / values.count.to_f
        end
      end

      # class QueryableSession < ActiveType::Record[Session::Closed]
      #   include PatientScope
      #   scope :auditable_sessions_for, ->(patient) { for_patient(patient).limit(12).ordered }
      # end
    end
  end
end
