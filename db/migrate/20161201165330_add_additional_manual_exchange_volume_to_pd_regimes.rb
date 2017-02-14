class AddAdditionalManualExchangeVolumeToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes,
               :additional_manual_exchange_volume,
               :integer
  end
end
