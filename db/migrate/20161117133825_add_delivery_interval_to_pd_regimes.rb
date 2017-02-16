class AddDeliveryIntervalToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :delivery_interval, :integer
  end
end
