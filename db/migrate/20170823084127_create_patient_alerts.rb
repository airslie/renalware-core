class CreatePatientAlerts < ActiveRecord::Migration[5.1]
  def change
    create_table :patient_alerts do |t|
      t.references :patient, null: false, foreign_key: true
      t.text :notes
      t.boolean :urgent, default: false, null: false
      t.integer :created_by_id, index: true, null: false
      t.integer :updated_by_id, index: true, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_foreign_key :patient_alerts, :users, column: :created_by_id
    add_foreign_key :patient_alerts, :users, column: :updated_by_id
  end
end
