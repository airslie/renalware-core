class AddUuidToHDTransmissionLogs < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hd_transmission_logs,
                 :uuid,
                 :uuid,
                 default: "uuid_generate_v4()",
                 null: false
    end
  end
end
