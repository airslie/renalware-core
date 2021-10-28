class AddVisitNumberToClinicAppointments < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_appointments, :visit_number, :text
      add_index :clinic_appointments, :visit_number
    end
  end
end
