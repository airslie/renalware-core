class AddStatusToClinicAppointments < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :clinic_appointments, :status, :text
    end
  end
end
