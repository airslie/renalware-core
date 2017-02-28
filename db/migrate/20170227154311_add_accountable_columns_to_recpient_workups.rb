class AddAccountableColumnsToRecpientWorkups < ActiveRecord::Migration[5.0]
  def change
    add_column :transplant_recipient_workups, :created_by_id, :integer, null: false
    add_column :transplant_recipient_workups, :updated_by_id, :integer, null: false
    add_index :transplant_recipient_workups, :created_by_id
    add_index :transplant_recipient_workups, :updated_by_id
  end
end
