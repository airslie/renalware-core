class AddColsToAKIAlerts < ActiveRecord::Migration[5.1]
  def change
    add_column :renal_aki_alerts, :max_cre, :integer
    add_column :renal_aki_alerts, :cre_date, :date
    add_column :renal_aki_alerts, :max_aki, :integer
    add_column :renal_aki_alerts, :aki_date, :date
    remove_column :renal_aki_alerts, :string, :string
  end
end
