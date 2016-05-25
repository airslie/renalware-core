class AddAccountableFieldsToPatients < ActiveRecord::Migration
  def change
      add_column :patients, :created_by_id, :integer, null: false
      add_column :patients, :updated_by_id, :integer, null: false
      add_index :patients, :created_by_id
      add_index :patients, :updated_by_id
  end
end
