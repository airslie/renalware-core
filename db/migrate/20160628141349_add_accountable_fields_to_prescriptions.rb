class AddAccountableFieldsToPrescriptions < ActiveRecord::Migration[4.2]
  def change
    add_column :medication_prescriptions, :created_by_id, :integer, null: false, index: true
    add_column :medication_prescriptions, :updated_by_id, :integer, null: false, index: true

    add_foreign_key :medication_prescriptions, :users, column: :created_by_id
    add_foreign_key :medication_prescriptions, :users, column: :updated_by_id
  end
end
