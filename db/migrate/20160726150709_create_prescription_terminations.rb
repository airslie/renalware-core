class CreatePrescriptionTerminations < ActiveRecord::Migration
  def change
    create_table :medication_prescription_terminations do |t|
      t.date :terminated_on, null: false
      t.text :notes
      t.references :prescription, index: true, null: false
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :medication_prescription_terminations, :medication_prescriptions, column: :prescription_id
    add_foreign_key :medication_prescription_terminations, :users, column: :created_by_id
    add_foreign_key :medication_prescription_terminations, :users, column: :updated_by_id
  end
end
