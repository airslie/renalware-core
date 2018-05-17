class CreateViewPatientCurrentModalities < ActiveRecord::Migration[5.1]
  def change
    create_view :patient_current_modalities
  end
end
