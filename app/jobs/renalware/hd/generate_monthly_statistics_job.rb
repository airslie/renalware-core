# This job when executed will store a snapshot of last month's HD session statistics
# for each HD patient.
module Renalware
  module HD
    class GenerateMonthlyStatisticsJob < ApplicationJob
      queue_as :hd_patient_statistics

      # :reek:UtilityFunction
      def perform
        patients.each do |patient|
          GenerateMonthlyStatisticsForPatientJob.perform_later(
            patient: patient,
            month: month,
            year: year
          )
        end
      end

      private

      def patients
        @patients ||= Sessions::AuditablePatientsInPeriodQuery.new(period: period).call
      end

      def period
        @period ||= MonthPeriod.new(month: month, year: year)
      end

      def month
        date_falling_in_the_previous_month.month
      end

      def year
        date_falling_in_the_previous_month.year
      end

      def date_falling_in_the_previous_month
        @date ||= Time.zone.today - 1.month
      end
    end
  end
end
