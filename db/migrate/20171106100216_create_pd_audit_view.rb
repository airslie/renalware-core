class CreatePDAuditView < ActiveRecord::Migration[5.1]
  def change
    create_view :reporting_pd_audit
  end
end
