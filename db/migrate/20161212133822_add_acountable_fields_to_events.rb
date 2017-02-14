class AddAcountableFieldsToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :created_by_id, :integer, null: false
    add_column :events, :updated_by_id, :integer, null: false
    add_index :events, :created_by_id
    add_index :events, :updated_by_id
  end
end
