class AddRequiresBbvSlotToHDSlotRequests < ActiveRecord::Migration[8.0]
  def change
    within_renalware_schema do
      add_column :hd_slot_requests, :requires_bbv_slot, :boolean, null: false, default: false
    end
  end
end
