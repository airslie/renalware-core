class ChangeUKRDCTransmissionLogErrorType < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      change_column(:ukrdc_transmission_logs, :error, "text[] USING (string_to_array(error, ','))")
      change_column_default(:ukrdc_transmission_logs, :error, [])
    end
  end

  def down
    within_renalware_schema do
      change_column(:ukrdc_transmission_logs, :error, :text, array: false)
      change_column_default(:ukrdc_transmission_logs, :error, nil)
    end
  end
end
