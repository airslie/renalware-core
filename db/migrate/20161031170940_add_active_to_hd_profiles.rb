class AddActiveToHDProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :hd_profiles, :deactivated_at, :datetime, index: true
    add_column :hd_profiles, :active, :boolean, null: true, default: true
    add_index :hd_profiles, [:active, :patient_id], unique: true
  end
end
