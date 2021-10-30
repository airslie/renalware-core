class AddCounterCachesToClinics < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :clinic_clinics, :appointments_count, :integer, default: 0
      add_column :clinic_clinics, :clinic_visits_count, :integer, default: 0
    end
  end
end
