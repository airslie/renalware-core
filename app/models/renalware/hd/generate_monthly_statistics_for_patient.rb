module Renalware
  module HD
    class GenerateMonthlyStatisticsForPatient
      def initialize(patient:, period:)
        @patient = patient
        @period = period
      end

      def call
        options = { patient: patient, period: period }
        sessions = Sessions::AuditablePatientSessionsInPeriodQuery.new(**options).call
        create_patient_statistics(sessions)
      end

      private

      attr_reader :period, :patient

      def create_patient_statistics(sessions)
        return unless sessions.any?
        stats = build_patient_statistics
        stats.hospital_unit = most_recently_used_hospital_unit(sessions)
        stats.assign_attributes(auditable_sessions(sessions).to_h)
        stats.session_count = sessions.length
        stats.save!
      end

      def build_patient_statistics
        PatientStatistics.where(
          patient: patient,
          month: period.month,
          year: period.year,
          rolling: nil
        ).first_or_initialize
      end

      def auditable_sessions(sessions)
        Sessions::AuditableSessionCollection.new(sessions)
      end

      def most_recently_used_hospital_unit(sessions)
        sessions.last&.hospital_unit
      end
    end
  end
end
