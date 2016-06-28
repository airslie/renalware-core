class AddAccountableFieldsToMedications < ActiveRecord::Migration
  def change
    add_column :medications, :created_by_id, :integer, null: false
    add_column :medications, :updated_by_id, :integer, null: false
    add_index :medications, :created_by_id
    add_index :medications, :updated_by_id
  end
end
