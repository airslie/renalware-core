class CreateClinicsAppointments < ActiveRecord::Migration
  def change
    create_table :clinics_appointments do |t|
      t.datetime :starts_at, null: false
      t.integer :patient_id, null: false
      t.integer :user_id, null: false
      t.integer :clinic_id, null: false
    end

    add_foreign_key :clinics_appointments, :patients
    add_foreign_key :clinics_appointments, :users
    add_foreign_key :clinics_appointments, :clinics
  end
end
