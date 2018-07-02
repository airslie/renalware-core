class CreateHDTransmissionLog < ActiveRecord::Migration[5.1]
  def change
    create_table :hd_transmission_logs do |t|
      t.string :direction, null: false, index: true
      t.string :format, null: false, index: true
      t.string :status, index: true
      t.references :hd_provider_unit, foreign_key: true, index: true
      t.references :patient, foreign_key: true, index: true
      t.string :filepath
      t.text :payload
      t.jsonb :result, index: { using: :gin }, default: {}
      t.text :error
      t.datetime :transmitted_at, index: true
      t.timestamps null: false
      t.timestamps null: false
    end
  end
end
