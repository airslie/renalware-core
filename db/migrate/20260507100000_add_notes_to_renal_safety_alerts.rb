class AddNotesToRenalSafetyAlerts < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :renal_safety_alerts, :notes, :text
    end
  end
end
