class CreatePrescriptionAdministrations < ActiveRecord::Migration[5.0]
  def change
    create_table :hd_prescription_administrations do |t|
      t.references :hd_session, index: true, null: false
      t.integer :prescription_id, null: false, index: true
      t.boolean :administered, null: false
      t.text :notes, null: true
      t.references :created_by, index: true, null: false
      t.references :updated_by, index: true, null: false
      t.timestamps null: false
    end

    add_foreign_key :hd_prescription_administrations, :users, column: :created_by_id
    add_foreign_key :hd_prescription_administrations, :users, column: :updated_by_id
    add_foreign_key :hd_prescription_administrations, :hd_sessions, column: :hd_session_id
    add_foreign_key :hd_prescription_administrations,
                    :medication_prescriptions,
                    column: :prescription_id
  end
end
