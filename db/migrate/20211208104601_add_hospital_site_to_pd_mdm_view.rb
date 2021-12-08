class AddHospitalSiteToPDMDMView < ActiveRecord::Migration[5.2]
  def up
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 5
    end
  end

  def down
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 4
    end
  end
end
