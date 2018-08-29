# frozen_string_literal: true

require "month_period"

module Renalware
  module HD
    class GenerateMonthlyStatisticsForPatientJob < ApplicationJob
      queue_with_priority 2
      queue_as :hd_patient_statistics

      # :reek:UtilityFunction
      def perform(patient:, month:, year:)
        period = Renalware::MonthPeriod.new(month: month, year: year)
        GenerateMonthlyStatisticsForPatient.new(patient: patient, period: period).call
      end
    end
  end
end
