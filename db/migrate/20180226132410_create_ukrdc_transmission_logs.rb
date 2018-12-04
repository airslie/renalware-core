class CreateUKRDCTransmissionLogs < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table :ukrdc_transmission_logs do |t|
        t.references :patient, foreign_key: true, index: true, null: false
        t.datetime :sent_at, null: false
        t.integer :status, null: false
        t.uuid :request_uuid, null: false, index: true
        t.text :payload_hash
        t.xml :payload
        t.text :error
        t.string :file_path
        t.timestamps null: false
      end
    end
  end
end
