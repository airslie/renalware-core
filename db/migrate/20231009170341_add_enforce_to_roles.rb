class AddEnforceToRoles < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :roles, :enforce, :boolean, default: false, null: false
      end
    end
  end
end
