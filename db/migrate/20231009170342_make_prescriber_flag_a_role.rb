class MakePrescriberFlagARole < ActiveRecord::Migration[7.0]
  def up
    within_renalware_schema do
      # Ensure role name is unique - remove the old index and add a unique one
      safety_assured do
        remove_index :roles, :name
        add_index :roles, :name, unique: true
      end

      # This finds or creates all roles including hd_prescriber and hd_prescriber
      Renalware::Role.install!

      prescriber_role = Renalware::Role.find_by!(name: "prescriber")

      # For each user with prescriber = true, give them the new Prescriber role.
      Renalware::User.where(prescriber: true).find_each do |user|
        user.roles << prescriber_role
      end
    end
  end

  def down
    remove_index :roles, :name
    add_index :roles, :name

    prescriber_role = Renalware::Role.find_by!(name: "prescriber")
    Renalware::RolesUser.where(role_id: prescriber_role.id).destroy_all
    prescriber_role.destroy!
  end
end
