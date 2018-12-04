class ReportingAuditChanges < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      rename_column :reporting_audits, :materialized_view_name, :view_name
      add_column :reporting_audits, :materialized, :boolean, null: false, default: true
      change_column_null :reporting_audits, :refresh_schedule, true
    end
  end
end
