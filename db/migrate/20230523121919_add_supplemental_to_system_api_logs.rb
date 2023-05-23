class AddSupplementalToSystemAPILogs < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      add_column :system_api_logs, :values, :text, array: true, default: []
    end
  end
end
