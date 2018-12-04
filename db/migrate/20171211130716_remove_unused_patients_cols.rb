class RemoveUnusedPatientsCols < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      remove_column :patients, :pct_org_code, :string
      remove_column :patients, :gp_practice_code, :string
    end
  end
end
