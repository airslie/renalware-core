class RenameESRFIntoToESRF < ActiveRecord::Migration
  def change
    rename_table :esrf_infos, :esrf
  end
end
