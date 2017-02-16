class AddSystemIdToPDRegimes < ActiveRecord::Migration[4.2]
  def change
    add_column :pd_regimes, :system_id, :integer
  end
end
