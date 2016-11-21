class RemoveLastFillVolumeFromPDRegime < ActiveRecord::Migration
  def change
    remove_column :pd_regimes, :last_fill_volume, :integer
  end
end
