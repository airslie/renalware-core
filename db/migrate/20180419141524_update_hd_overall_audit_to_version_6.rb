class UpdateHDOverallAuditToVersion6 < ActiveRecord::Migration[5.1]
  def change
    update_view :reporting_hd_overall_audit,
                materialized: true,
                version: 6,
                revert_to_version: 5
  end
end
