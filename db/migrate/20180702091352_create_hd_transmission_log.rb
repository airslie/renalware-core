class CreateHDTransmissionLog < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_table "renalware.hd_transmission_logs" do |t|
        t.references :parent, index: true
        t.string :direction, null: false, index: true
        t.string :format, null: false, index: true
        t.string :status, index: true
        t.references :hd_provider_unit, foreign_key: true, index: true
        t.references :patient, foreign_key: true, index: true
        t.string :filepath
        t.text :payload
        t.jsonb :result, index: { using: :gin }, default: {}
        t.text :error_messages, array: true, default: []
        t.datetime :transmitted_at, index: true
        t.timestamps null: false
      end
    end
  end
end
