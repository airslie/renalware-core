class RenameClinicTables < ActiveRecord::Migration[5.0]
  def change
    rename_table :clinics, :clinic_clinics
    rename_table :clinics_appointments, :clinic_appointments
  end
end
