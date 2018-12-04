class RemoveRogueAKIAlertsColumn < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_column :renal_aki_alerts, :renal_aki_alerts, :string
    end
  end
end
