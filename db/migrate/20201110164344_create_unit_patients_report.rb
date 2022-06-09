class CreateUnitPatientsReport < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      create_view :reporting_unit_patients
    end
  end
end
