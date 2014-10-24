class AddCodesToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :gp_practice_code, :string
    add_column :patients, :pct_org_code, :string
    add_column :patients, :hosp_centre_code, :string
    add_column :patients, :primary_esrf_centre, :string
  end
end
