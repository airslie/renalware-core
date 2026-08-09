class AddStatsReportForeignKeyToMirthChannelStats < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_foreign_key(
        :monitoring_mirth_channel_stats,
        :monitoring_mirth_stats_reports,
        column: :stats_report_id,
        validate: false
      )
    end
  end
end
