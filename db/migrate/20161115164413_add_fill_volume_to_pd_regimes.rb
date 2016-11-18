class AddFillVolumeToPDRegimes < ActiveRecord::Migration
  def change
    add_column :pd_regimes, :fill_volume, :integer
  end
end
