class CreatePatientModalities < ActiveRecord::Migration
  def change
    create_table :modalities do |t|
      t.integer :patient_id
      t.integer :modality_description_id
      t.integer :reason_id
      t.string :modal_change_type
      t.text :notes
      t.date :started_on
      t.date :ended_on
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
