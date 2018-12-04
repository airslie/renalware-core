class CreateHDGroupedTransmissionLogsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :hd_grouped_transmission_logs
    end
  end
end
