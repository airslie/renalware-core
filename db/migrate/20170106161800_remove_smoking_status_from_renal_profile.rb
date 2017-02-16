class RemoveSmokingStatusFromRenalProfile < ActiveRecord::Migration[4.2]
  def change
    remove_column :renal_profiles, :smoking_status, :string
  end
end
