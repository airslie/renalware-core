class AddEthnicityIdToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :ethnicity_id, :integer
    remove_column :patients, :ethnic_category, :string
  end
end
