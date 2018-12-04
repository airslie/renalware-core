class UpdateHDOverallAuditToVersion7 < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      update_view :reporting_hd_overall_audit,
                  materialized: true,
                  version: 7,
                  revert_to_version: 6
    end
  end
end
