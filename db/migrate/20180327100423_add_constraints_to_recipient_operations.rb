class AddConstraintsToRecipientOperations < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:transplant_recipient_operations, :patient_id, false)
  end
end
