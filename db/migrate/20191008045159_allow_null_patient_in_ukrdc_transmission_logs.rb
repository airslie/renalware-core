class AllowNullPatientInUKRDCTransmissionLogs < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_column_null :ukrdc_transmission_logs, :patient_id, true
      add_column :ukrdc_transmission_logs, :direction, :integer, null: false, default: 0
    end
  end
end
