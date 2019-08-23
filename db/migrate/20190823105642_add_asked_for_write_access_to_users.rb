class AddAskedForWriteAccessToUsers < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :users, :asked_for_write_access, :boolean, default: false, null: false
    end
  end
end
