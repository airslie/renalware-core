class CreatePatientMedications < ActiveRecord::Migration
  def change
    create_table :patient_medications do |t|
      t.integer :patient_id
      t.integer :medication_id
      t.integer :user_id
      t.string :medication_type 
      t.string :dose
      t.string :route
      t.string :frequency
      t.text :notes
      t.date :date
      t.string :provider
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
