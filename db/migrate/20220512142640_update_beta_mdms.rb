class UpdateBetaMDMs < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :akcc_mdm_patients, version: 4, revert_to_version: 3
      update_view :hd_mdm_patients, version: 6, revert_to_version: 5
      update_view :pd_mdm_patients, version: 6, revert_to_version: 5
      update_view :supportive_care_mdm_patients, version: 5, revert_to_version: 4
      update_view :transplant_mdm_patients, version: 5, revert_to_version: 4
    end
  end
end
