class CreateReportingAnaemiaAudit < ActiveRecord::Migration[5.0]
  def change
    within_renalware_schema do
      create_view :reporting_anaemia_audit
    end
  end
end
