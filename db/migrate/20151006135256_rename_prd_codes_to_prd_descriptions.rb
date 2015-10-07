class RenamePRDCodesToPRDDescriptions < ActiveRecord::Migration
  def change
    rename_table :prd_codes, :prd_descriptions
    rename_column :esrf, :prd_code_id, :prd_description_id
  end
end
