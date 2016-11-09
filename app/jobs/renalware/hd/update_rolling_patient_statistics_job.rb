# When executed this job updates rolling statistics for a patient's
# last past 12 HD sessions.

module Renalware
  module HD
    class UpdateRollingPatientStatisticsJob < ActiveJob::Base
      queue_as :hd_patient_statistics

      # :reek:UtilityFunction
      def perform(patient)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end
    end
  end
end
