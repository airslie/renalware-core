class AddActiveToHDProfiles < ActiveRecord::Migration
  def change
    add_column :hd_profiles, :active, :boolean, null: true, default: true
    add_index :hd_profiles, [:active, :patient_id], unique: true
  end
end
