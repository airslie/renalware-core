class RemoveAddManualExchangeFromPDRegimes < ActiveRecord::Migration[4.2]
  def change
    remove_column :pd_regimes, :add_manual_exchange, :boolean
    add_column :pd_regime_bags, :role, :string
  end
end
