class AddAssistanceTypeToPDRegime < ActiveRecord::Migration[5.0]
  def change
    add_column :pd_regimes, :assistance_type, :string
  end
end
