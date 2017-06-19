class AddColumnsToAccessType < ActiveRecord::Migration[5.0]
  def change
    remove_column :access_types, :code
    add_column :access_types, :rr02_code, :string, null: true
    add_column :access_types, :rr41_code, :string, null: true
  end
end
