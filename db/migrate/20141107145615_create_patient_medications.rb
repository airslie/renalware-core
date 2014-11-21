class CreatePatientMedications < ActiveRecord::Migration
  def up
    create_table :patient_medications do |t|
      t.integer :patient_id
      t.integer :medication_id
      t.integer :user_id
      t.string :medication_type 
      t.string :dose
      t.integer :route
      t.string :frequency
      t.text :notes
      t.date :date
      t.integer :provider
      t.datetime :deleted_at
      t.timestamps
    end
  end
  
  def down
    drop_table :patient_medications 
  end
end
