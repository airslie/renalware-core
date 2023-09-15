class AddExternalReferralToHDSlotRequests < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :hd_slot_requests, :external_referral, :boolean, default: false, null: false
    end
  end
end
