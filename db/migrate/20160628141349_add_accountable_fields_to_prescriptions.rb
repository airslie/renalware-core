class AddAccountableFieldsToPrescriptions < ActiveRecord::Migration
  def change
    add_column :medication_prescriptions, :created_by_id, :integer, null: false
    add_column :medication_prescriptions, :updated_by_id, :integer, null: false
    add_index :medication_prescriptions, :created_by_id
    add_index :medication_prescriptions, :updated_by_id
  end
end
