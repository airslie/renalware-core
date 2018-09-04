# frozen_string_literal: true

begin
  namespace :audit do
    desc <<-DESC
      Queues delayed jobs to generate monthly HD audits for each patient with a signed-off HD
      Session in the specified month and year. If no year or month supplied, it will generate
      stats for last month for each patient.

      Example usage:

      To generate monthly stats for last month:
        bundle exec rake audit:patient_hd_statistics

      To generate monthly stats for a specific month:
        bundle exec rake audit:patient_hd_statistics year=2018 month=5

    DESC
    task patient_hd_statistics: :environment do
      logger           = Logger.new(STDOUT)
      logger.level     = Logger::INFO
      Rails.logger     = logger

      Renalware::HD::GenerateMonthlyStatistics.new(
        month: ENV["month"],
        year: ENV["year"]
      ).call

      # Refresh the materialized view which will aggregate the monthly hd_patient_statistics data
      RefreshMaterializedViewJob.perform_later(view_name: "renalware.reporting_hd_overall_audit")
    end
  end
end
