class RemoveDeletedAtFromAdmissionConsults < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_column :admission_consults, :deleted_at, :datetime
    end
  end
end
