class AddTherapyTimeToPDRegime < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :therapy_time, :integer
  end
end
