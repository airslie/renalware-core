class CreateReportingHDOverallAudit < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_hd_overall_audit, materialized: true
  end
end
