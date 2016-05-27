class AddDemographicColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :title, :string
    add_column :patients, :suffix, :string
    add_column :patients, :marital_status, :string
    add_column :patients, :telephone1, :string
    add_column :patients, :telephone2, :string
    add_column :patients, :email, :string
  end
end
