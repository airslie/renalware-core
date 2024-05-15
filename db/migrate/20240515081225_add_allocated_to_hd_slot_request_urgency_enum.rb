class AddAllocatedToHDSlotRequestUrgencyEnum < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_enum_value :enum_hd_slot_request_urgency, "allocated"
    end
  end
end
