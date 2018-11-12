class UpdateHDOverallAuditToVersion9 < ActiveRecord::Migration[5.1]
  update_view :reporting_hd_overall_audit,
              materialized: true,
              version: 9,
              revert_to_version: 8
end
