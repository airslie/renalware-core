class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration[4.2]
  # rubocop:disable Rails/CreateTableWithTimestamps
  def change
    create_table :roles_users, id: false do |t|
      t.references :role, :user
    end

    add_foreign_key :roles_users, :users, column: :user_id
    add_foreign_key :roles_users, :roles, column: :role_id
  end
  # rubocop:enable Rails/CreateTableWithTimestamps
end
