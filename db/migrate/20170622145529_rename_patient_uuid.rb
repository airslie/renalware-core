class RenamePatientUuid < ActiveRecord::Migration[5.0]
  def change
    rename_column :patients, :uuid, :ukrdc_external_id
  end
end
