class AddAccountableFieldsToPrescriptions < ActiveRecord::Migration
  def change
    add_column :prescriptions, :created_by_id, :integer, null: false
    add_column :prescriptions, :updated_by_id, :integer, null: false
    add_index :prescriptions, :created_by_id
    add_index :prescriptions, :updated_by_id
  end
end
