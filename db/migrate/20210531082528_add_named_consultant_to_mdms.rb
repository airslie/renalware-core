class AddNamedConsultantToMDMs < ActiveRecord::Migration[5.2]
  def change
    update_view(:akcc_mdm_patients, version: 2, revert_to_version: 1)
    update_view(:hd_mdm_patients, version: 4, revert_to_version: 3)
    update_view(:pd_mdm_patients, version: 4, revert_to_version: 3)
    update_view(:supportive_care_mdm_patients, version: 3, revert_to_version: 2)
    update_view(:transplant_mdm_patients, version: 3, revert_to_version: 2)
  end
end
