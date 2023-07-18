class AddUrineGlucoseToClinicVisits < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      add_column :clinic_visits, :urine_glucose, :string
    end
  end
end
