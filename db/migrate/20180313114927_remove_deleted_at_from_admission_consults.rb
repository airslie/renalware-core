class RemoveDeletedAtFromAdmissionConsults < ActiveRecord::Migration[5.1]
  def change
    remove_column :admission_consults, :deleted_at, :datetime
  end
end
