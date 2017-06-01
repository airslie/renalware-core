class MakePDRegimeDeliveryIntervalAString < ActiveRecord::Migration[5.0]
  def change
    change_column :pd_regimes, :delivery_interval, :string
  end
end
