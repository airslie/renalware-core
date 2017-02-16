class AddDailyVolumeToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :daily_volume, :integer
    rename_column :pd_regimes, :overnight_pd_volume, :overnight_volume
  end
end
