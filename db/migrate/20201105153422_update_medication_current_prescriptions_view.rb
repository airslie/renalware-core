class UpdateMedicationCurrentPrescriptionsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      replace_view :medication_current_prescriptions, version: 2, revert_to_version: 1
    end
  end
end
