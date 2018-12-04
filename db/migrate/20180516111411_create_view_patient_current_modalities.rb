class CreateViewPatientCurrentModalities < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_view :patient_current_modalities
    end
  end
end
