class UpdateHDOverallAuditToVersion8 < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      update_view :reporting_hd_overall_audit,
                  materialized: true,
                  version: 8,
                  revert_to_version: 7
    end
  end
end
