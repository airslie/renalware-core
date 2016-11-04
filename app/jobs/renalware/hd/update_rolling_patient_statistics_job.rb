module Renalware
  module HD
    class UpdateRollingPatientStatisticsJob < ActiveJob::Base
      queue_as :default

      # :reek:UtilityFunction
      def perform(patient)
        UpdateRollingPatientStatistics.new(patient: patient).call
      end
    end
  end
end
