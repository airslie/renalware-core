class AddDescriptionsToReportingAudits < ActiveRecord::Migration[5.0]
  def change
    add_column :reporting_audits, :description, :text
  end
end
