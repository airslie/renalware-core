class AddHostSiteToHospitalCentres < ActiveRecord::Migration[5.2]
  def change
    add_column :hospital_centres, :host_site, :boolean, default: false, null: false
    # Allow only one true value in the table at Barts. However at MSE there are 3 hosts sites
    # add_index :hospital_centres, :host_site, unique: true, where: "host_site = true"
    add_index :hospital_centres, :host_site
  end
end
