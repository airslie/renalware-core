class RemoveAddManualExchangeFromPDRegimes < ActiveRecord::Migration
  def change
    remove_column :pd_regimes, :add_manual_exchange
  end
end
