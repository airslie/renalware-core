class UpdateMDMViewsForNamedNurseChanges < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      update_view :hd_mdm_patients, version: 3, revert_to_version: 2
    end
  end
end
