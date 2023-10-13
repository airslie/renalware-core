class AddReferenceToHDSlotRequests < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      safety_assured do
        add_reference :hd_slot_requests,
                      :deletion_reason,
                      foreign_key: { to_table: :hd_slot_request_deletion_reasons },
                      index: true
      end
    end
  end
end
