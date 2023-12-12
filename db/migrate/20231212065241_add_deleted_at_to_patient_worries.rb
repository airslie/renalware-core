class AddDeletedAtToPatientWorries < ActiveRecord::Migration[7.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :patient_worries, :deleted_at, :datetime
        add_index :patient_worries, :deleted_at
        remove_index :patient_worries, :patient_id
        add_index :patient_worries, :patient_id, unique: true, where: "deleted_at is null"
      end
    end
  end
end
