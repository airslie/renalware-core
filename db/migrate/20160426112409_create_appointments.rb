class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :starts_at, null: false
      t.integer :patient_id, null: false
      t.integer :user_id, null: false
      t.integer :clinic_id, null: false
    end
  end
end
