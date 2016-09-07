class MoveDoctorsTablesToPatientsNamespace < ActiveRecord::Migration
  def change
    rename_table :doctor_doctors, :patient_primary_care_physicians
    rename_table :doctor_practices, :patient_practices
    rename_table :doctor_doctors_practices, :patient_practices_primary_care_physicians

    rename_column :patient_practices_primary_care_physicians, :doctor_id, :primary_care_physician_id
    add_index(:patient_practices_primary_care_physicians, :practice_id)
    add_foreign_key :patient_practices_primary_care_physicians, :patient_primary_care_physicians, column: :primary_care_physician_id
    add_foreign_key :patient_practices_primary_care_physicians, :patient_practices, column: :practice_id

    rename_column :patients, :doctor_id, :primary_care_physician_id
    add_foreign_key :patients, :patient_primary_care_physicians, column: :primary_care_physician_id
  end
end
