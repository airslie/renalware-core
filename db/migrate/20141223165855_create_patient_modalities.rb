class CreatePatientModalities < ActiveRecord::Migration
  def change
    create_table :patient_modalities do |t|
      t.integer :patient_id
      t.integer :modality_code_id
      t.integer :modality_reason_id
      t.string :modal_change_type
      t.text :notes   
      t.date :date
      t.datetime :deleted_at       
      t.timestamps
    end
  end
end
