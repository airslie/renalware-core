class AddDeathColumnsToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :first_edta_code_id, :integer
    add_column :patients, :second_edta_code_id, :integer
    add_column :patients, :death_details, :text
  end
end
