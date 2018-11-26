class RefreshHDGroupedTransmissionLogsView < ActiveRecord::Migration[5.2]
  include MigrationHelper

  def change
    within_renalware_schema do
      drop_view :hd_grouped_transmission_logs
      create_view :hd_grouped_transmission_logs
    end
  end
end
