class RemoveSmokingStatusFromRenalProfile < ActiveRecord::Migration
  def change
    remove_column :renal_profiles, :smoking_status, :string
  end
end
