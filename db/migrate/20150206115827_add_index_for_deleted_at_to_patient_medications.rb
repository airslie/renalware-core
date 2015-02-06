class AddIndexForDeletedAtToPatientMedications < ActiveRecord::Migration
  def change
    add_index :patient_medications, :deleted_at
  end
end
