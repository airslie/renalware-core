class AddUniqueIndexToUserRoles < ActiveRecord::Migration[5.0]
  def change
    remove_index :roles_users, [:user_id, :role_id]
    add_index :roles_users, [:user_id, :role_id], unique: true

    add_column :roles, :hidden, :boolean, default: false, null: false
  end
end
