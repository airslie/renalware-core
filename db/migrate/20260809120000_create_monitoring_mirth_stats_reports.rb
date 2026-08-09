class CreateMonitoringMirthStatsReports < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      create_table :monitoring_mirth_stats_reports do |t|
        t.uuid :report_id, null: false
        t.string :source, null: false
        t.string :site_id, null: false
        t.string :instance_id, null: false
        t.uuid :server_id
        t.datetime :reported_at, null: false
        t.references :api_credential, null: false, foreign_key: true, index: true

        t.timestamps null: false
      end

      add_index :monitoring_mirth_stats_reports, :report_id, unique: true
      add_index(
        :monitoring_mirth_stats_reports,
        %i(site_id instance_id reported_at),
        name: "idx_mirth_stats_reports_on_instance_and_reported_at"
      )
    end
  end
end
