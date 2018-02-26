class CreateUKRDCTransmissionLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :ukrdc_transmission_logs do |t|
      t.references :patient, foreign_key: true, index: { unique: true }, null: false
      t.datetime :sent_at, null: false
      t.string :result
      t.xml :payload
      t.text :payload_hash
      t.text :error
      t.timestamps null: false
    end
  end
end
