class AddSystemIdToPDRegimes < ActiveRecord::Migration
  def change
    add_column :pd_regimes, :system_id, :integer
  end
end
