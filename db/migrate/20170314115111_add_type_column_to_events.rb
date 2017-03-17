class AddTypeColumnToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :type, :string, null: false
    add_index :events, :type
  end
end
