class AddIdToRolesUsers < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :roles_users, :id, :primary_key
    end
  end
end
