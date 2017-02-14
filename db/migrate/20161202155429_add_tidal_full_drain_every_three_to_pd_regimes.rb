class AddTidalFullDrainEveryThreeToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :tidal_full_drain_every_three_cycles, :boolean, default: true
  end
end
