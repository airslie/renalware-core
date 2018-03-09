class AddDwellTimeToPDRegime < ActiveRecord::Migration[5.1]
  def change
    add_column :pd_regimes, :dwell_time, :integer
  end
end
