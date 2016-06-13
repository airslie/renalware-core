class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :starts_at, null: false
      t.integer :patient_id, null: false
      t.integer :user_id, null: false
      t.integer :clinic_id, null: false
    end

    add_foreign_key :appointments, :patients
    add_foreign_key :appointments, :users
    add_foreign_key :appointments, :clinics
  end
end
