class RemoveSiteFromAccessProfile < ActiveRecord::Migration[5.0]
  def change
    remove_column :access_profiles, :site_id
  end
end
