class RemoveTxOperationConstraints < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      change_column_null :transplant_recipient_operations, :theatre_case_start_time, true
      change_column_null :transplant_recipient_operations, :donor_kidney_removed_from_ice_at, true
      change_column_null :transplant_recipient_operations, :kidney_perfused_with_blood_at, true
      change_column_null :transplant_recipient_operations, :warm_ischaemic_time, true
      change_column_null :transplant_recipient_operations, :cold_ischaemic_time, true
    end
  end
end
