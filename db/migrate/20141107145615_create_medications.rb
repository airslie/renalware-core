class CreateMedications < ActiveRecord::Migration
  def up
    create_table :medications do |t|
      t.integer :patient_id
      t.references :medicate_with, polymorphic: true, index: true
      t.integer :user_id
      t.string :medication_type 
      t.string :dose
      t.integer :medication_route_id    
      t.string :frequency
      t.text :notes
      t.date :date
      t.integer :provider
      t.datetime :deleted_at
      t.timestamps
    end
  end
  
  def down
    drop_table :medications 
  end
end
