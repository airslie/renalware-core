module Renalware
  module HD
    class UpdateRollingPatientStatistics

      def initialize(patient)
        @patient = patient
      end

      def call
        return unless recent_sessions.any?
        patient_rolling_stats.hospital_unit = most_recently_used_hospital_unit
        patient_rolling_stats.save!
      end

      private
      attr_reader :patient

      def recent_sessions
        @recent_sessions ||= begin
          Session.all
          # Sessions::PatientSessionsWithinPeriodQuery.call(patient: patient,
          #                                                 starting_on: 12.weeks.ago,
          #                                                 ending_on: Time.zone.now)
        end
      end

      def patient_rolling_stats
        @patient_rolling_stats ||= begin
          PatientStatistics.where(patient: patient,
                                  rolling: true,
                                  year: nil,
                                  month: nil).first_or_initialize
        end
      end

      def most_recently_used_hospital_unit
        recent_sessions.last.hospital_unit
      end
    end
  end
end
