class AddColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :nhs_number, :string
  end
end
