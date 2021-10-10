class AddScheduledTimeToHDProfiles < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :hd_profiles, :scheduled_time, :time, null: true
    end
  end
end
