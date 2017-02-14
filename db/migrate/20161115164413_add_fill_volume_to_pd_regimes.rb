class AddFillVolumeToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :fill_volume, :integer
  end
end
