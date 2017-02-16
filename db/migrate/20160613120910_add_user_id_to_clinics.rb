class AddUserIdToClinics < ActiveRecord::Migration[4.2]
  def change
    add_column :clinics, :user_id, :integer, null: false
    add_foreign_key :clinics, :users
  end
end
