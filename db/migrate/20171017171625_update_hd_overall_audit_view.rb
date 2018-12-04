class UpdateHDOverallAuditView < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      update_view :reporting_hd_overall_audit,
                  materialized: true,
                  version: 5,
                  revert_to_version: 4
    end
  end
end
