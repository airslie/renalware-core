class AssociateBatchWithUKRDCTransmissionLog < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      rename_table :ukrdc_batch_numbers, :ukrdc_batches
      change_column_null :ukrdc_transmission_logs, :request_uuid, true
      add_reference(
        :ukrdc_transmission_logs,
        :batch,
        foreign_key: { to_table: :ukrdc_batches },
        index: true,
        null: true
      )
    end
  end
end
