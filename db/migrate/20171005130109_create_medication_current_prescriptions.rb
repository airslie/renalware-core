class CreateMedicationCurrentPrescriptions < ActiveRecord::Migration[5.0]
  def change
    create_view :medication_current_prescriptions
  end
end
