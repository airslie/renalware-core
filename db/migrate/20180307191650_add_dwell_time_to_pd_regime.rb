class AddDwellTimeToPDRegime < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :pd_regimes, :dwell_time, :integer
    end
  end
end
