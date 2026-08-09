class AddReportToMonitoringMirthChannelStats < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def change
    within_renalware_schema do
      add_reference(
        :monitoring_mirth_channel_stats,
        :stats_report,
        index: false
      )
      add_column :monitoring_mirth_channel_stats, :state, :string
      add_index(
        :monitoring_mirth_channel_stats,
        %i(stats_report_id channel_id),
        unique: true,
        name: "idx_mirth_channel_stats_on_report_and_channel",
        algorithm: :concurrently
      )
    end
  end
end
