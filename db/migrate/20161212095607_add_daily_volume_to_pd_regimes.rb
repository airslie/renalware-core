class AddDailyVolumeToPDRegimes < ActiveRecord::Migration
  def change
    add_column :pd_regimes, :daily_volume, :integer
    rename_column :pd_regimes, :overnight_pd_volume, :overnight_volume
  end
end
