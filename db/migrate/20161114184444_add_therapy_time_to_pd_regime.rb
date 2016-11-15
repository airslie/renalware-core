class AddTherapyTimeToPDRegime < ActiveRecord::Migration
  def change
    add_column :pd_regimes, :therapy_time, :integer
  end
end
