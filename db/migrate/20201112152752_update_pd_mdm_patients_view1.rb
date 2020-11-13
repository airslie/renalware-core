class UpdatePDMDMPatientsView1 < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view :pd_mdm_patients, version: 3, revert_to_version: 2
    end
  end
end
