class UpdateViewsToExcludeDeletedSessions < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      update_view(
        :reporting_hd_blood_pressures_audit,
        version: 2,
        revert_to_version: 1,
        materialized: true
      )
    end
  end
end
