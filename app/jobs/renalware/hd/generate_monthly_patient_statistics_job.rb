# This job when executed will store a snapshot of last month's HD session statistics
# for each HD patient.
module Renalware
  module HD
    class GenerateMonthlyPatientStatisticsJob < ActiveJob::Base
      queue_as :default

      def perform
        GenerateMonthlyPatientStatistics.new.call(month: month, year: year)
      end

      private

      def date_falling_in_the_previous_month
        @date ||= Time.zone.today - 1.month
      end

      def month
        date_falling_in_the_previous_month.month
      end

      def year
        date_falling_in_the_previous_month.year
      end
    end
  end
end
