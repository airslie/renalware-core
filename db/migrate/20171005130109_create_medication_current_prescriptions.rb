class CreateMedicationCurrentPrescriptions < ActiveRecord::Migration[5.0]
  def change
    within_renalware_schema do
      create_view :medication_current_prescriptions
    end
  end
end
