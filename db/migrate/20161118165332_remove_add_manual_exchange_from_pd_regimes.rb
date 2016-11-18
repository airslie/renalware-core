class RemoveAddManualExchangeFromPDRegimes < ActiveRecord::Migration
  def change
    remove_column :pd_regimes, :add_manual_exchange, :boolean
    add_column :pd_regime_bags, :additional_manual_exchange, :boolean
  end
end
