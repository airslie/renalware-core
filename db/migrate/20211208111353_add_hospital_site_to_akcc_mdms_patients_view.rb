class AddHospitalSiteToAKCCMDMsPatientsView < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      update_view :akcc_mdm_patients, version: 3
    end
  end

  def down
    within_renalware_schema do
      update_view :akcc_mdm_patients, version: 2
    end
  end
end
