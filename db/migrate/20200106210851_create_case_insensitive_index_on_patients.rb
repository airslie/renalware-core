# In theory Devise will downcase emails when storing, but where data is migrated (and the
# database updated directly and not via Devise), duplicate email addreseses become possible if
# the case varies. It is this scenario we are keen to address.
class CreateCaseInsensitiveIndexOnPatients < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      remove_index :users, :email
      remove_index :users, :username
      add_index :users, "lower(email)", unique: true, name: "index_users_on_lower_email"
      add_index :users, "lower(username)", unique: true, name: "index_users_on_lower_username"
    end
  end

  def down
    within_renalware_schema do
      remove_index :users, name: "index_users_on_lower_email"
      remove_index :users, name: "index_users_on_lower_username"
      add_index :users, :email, unique: true
      add_index :users, :username, unique: true
    end
  end
end
