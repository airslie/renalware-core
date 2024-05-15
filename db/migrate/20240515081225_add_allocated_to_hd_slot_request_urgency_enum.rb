class AddAllocatedToHDSlotRequestUrgencyEnum < ActiveRecord::Migration[7.1]
  disable_ddl_transaction! # required for add_enum_value

  def change
    within_renalware_schema do
      add_enum_value :enum_hd_slot_request_urgency, "allocated"
    end
  end
end
