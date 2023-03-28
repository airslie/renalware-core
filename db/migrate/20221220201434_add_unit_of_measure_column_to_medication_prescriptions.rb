class AddUnitOfMeasureColumnToMedicationPrescriptions < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_reference :medication_prescriptions, :unit_of_measure,
                      foreign_key: { to_table: :drug_unit_of_measures }

        change_column_null :medication_prescriptions, :dose_unit, true
      end
    end
  end
end
