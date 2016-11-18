class AddDeliveryIntervalToPDRegimes < ActiveRecord::Migration
  def change
    add_column :pd_regimes, :delivery_interval, :integer
  end
end
