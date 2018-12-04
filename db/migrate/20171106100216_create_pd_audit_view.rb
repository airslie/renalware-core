class CreatePDAuditView < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      create_view :reporting_pd_audit
    end
  end
end
