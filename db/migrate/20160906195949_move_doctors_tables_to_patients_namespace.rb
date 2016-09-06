class MoveDoctorsTablesToPatientsNamespace < ActiveRecord::Migration
  def change
    rename_table :doctor_doctors, :patient_doctors
    rename_table :doctor_practices, :patient_practices
    rename_table :doctor_doctors_practices, :patient_doctors_practices
  end
end
