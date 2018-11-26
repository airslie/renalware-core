class AddWarningsToHDTransmissionLogs < ActiveRecord::Migration[5.2]
  def change
    add_column :hd_transmission_logs, :warnings, :string, array: true, default: []
  end
end
