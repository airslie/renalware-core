class RefactorESRF < ActiveRecord::Migration
  def change
    rename_table :esrf_infos, :esrf
    rename_column :esrf, :date, :diagnosed_on
  end
end
