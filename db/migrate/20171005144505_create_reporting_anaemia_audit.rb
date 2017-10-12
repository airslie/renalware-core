class CreateReportingAnaemiaAudit < ActiveRecord::Migration[5.0]
  def change
    create_view :reporting_anaemia_audit
  end
end
