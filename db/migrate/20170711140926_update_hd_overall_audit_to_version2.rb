class UpdateHDOverallAuditToVersion2 < ActiveRecord::Migration[5.0]
  def change
    update_view :reporting_hd_overall_audit,
                materialized: true,
                version: 2,
                revert_to_version: 1
  end
end
