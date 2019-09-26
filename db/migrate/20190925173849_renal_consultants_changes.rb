class RenalConsultantsChanges < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      remove_index :renal_consultants, :code
      change_column_null :renal_consultants, :code, true
      add_index :renal_consultants, :name, unique: true
    end
  end
end
