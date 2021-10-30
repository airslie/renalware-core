class AddAppointmentsCountToConsultants < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_consultants, :appointments_count, :integer, default: 0
    end
  end
end
