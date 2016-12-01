class AddAdditionalManualExchangeVolumeToPDRegimes < ActiveRecord::Migration
  def change
    add_column :pd_regimes,
               :additional_manual_exchange_volume,
               :integer
  end
end
