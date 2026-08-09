class ValidateStatsReportForeignKey < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      validate_foreign_key(
        :monitoring_mirth_channel_stats,
        :monitoring_mirth_stats_reports
      )
    end
  end
end
