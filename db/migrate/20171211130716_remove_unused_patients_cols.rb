class RemoveUnusedPatientsCols < ActiveRecord::Migration[5.1]
  def change
    remove_column :patients, :pct_org_code, :string
    remove_column :patients, :gp_practice_code, :string
  end
end
