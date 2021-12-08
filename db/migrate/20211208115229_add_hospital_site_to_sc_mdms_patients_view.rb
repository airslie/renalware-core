class AddHospitalSiteToScMDMsPatientsView < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      update_view :supportive_care_mdm_patients, version: 4
    end
  end

  def down
    within_renalware_schema do
      update_view :supportive_care_mdm_patients, version: 3
    end
  end
end
