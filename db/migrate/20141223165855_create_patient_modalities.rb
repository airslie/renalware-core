class CreatePatientModalities < ActiveRecord::Migration
  def change
    create_table :modalities do |t|
      t.integer :patient_id
      t.integer :modality_code_id
      t.integer :modality_reason_id
      t.string :modal_change_type
      t.text :notes
      t.date :start_date
      t.date :end_date
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
