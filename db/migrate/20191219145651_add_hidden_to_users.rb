class AddHiddenToUsers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :users, :hidden, :boolean, null: false, default: false
      add_index :users, :hidden
    end
  end
end
