class AddTimestampsToClinicAppointments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      change_table :clinic_appointments do |t|
        t.timestamps null: true
      end
    end
  end
end
