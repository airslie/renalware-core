class UpdateTransplantMDMPatientsView < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view :transplant_mdm_patients, version: 2, revert_to_version: 1
    end
  end
end
