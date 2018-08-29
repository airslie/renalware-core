# frozen_string_literal: true

# When executed this job updates rolling statistics for a patient's
# last past 12 HD sessions.

module Renalware
  module HD
    class UpdateRollingPatientStatisticsJob < ApplicationJob
      queue_as :hd_patient_statistics
      queue_with_priority 1

      # :reek:UtilityFunction
      def perform(patient)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end
    end
  end
end
