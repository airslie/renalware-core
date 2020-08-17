class CreateLowClearanceMDMPatients < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_view :low_clearance_mdm_patients
    end
  end
end
