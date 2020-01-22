class UpdatePatientCurrentModalities < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view :patient_current_modalities, version: 2, revert_to_version: 1
    end
  end
end
