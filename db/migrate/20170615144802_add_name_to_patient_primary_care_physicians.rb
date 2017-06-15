class AddNameToPatientPrimaryCarePhysicians < ActiveRecord::Migration[5.0]
  def change
    add_column :patient_primary_care_physicians, :deleted_at, :datetime
    add_column :patient_primary_care_physicians, :name, :string

    add_index :patient_primary_care_physicians, :deleted_at
    add_index :patient_primary_care_physicians, :name
  end
end
