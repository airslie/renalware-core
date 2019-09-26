# frozen_string_literal: true

# When executed this job updates rolling statistics for a patient's
# last past 12 HD sessions.
# Because this job will be triggered again the next time an HD Sessions is
# created, it is not crucial to keep each event around - ie they have a short
# shelf-life. For this reason we only retry 3 times then delete failed jobs.
module Renalware
  module HD
    UpdateRollingPatientStatisticsDjJob = Struct.new(:patient_id) do
      def perform
        patient = Renalware::HD::Patient.find(patient_id)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end

      def max_attempts
        3
      end

      def queue_name
        "hd_patient_statistics"
      end

      def priority
        4
      end

      def destroy_failed_jobs?
        true
      end

      # Retry at intervals of 1, 2, 3 hours
      def reschedule_at(current_time, attempts)
        current_time + attempts.hours
      end
    end
  end
end
