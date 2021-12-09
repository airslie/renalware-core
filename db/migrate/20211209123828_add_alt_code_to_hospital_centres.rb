class AddAltCodeToHospitalCentres < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_column :hospital_centres, :abbrev, :string
      add_index :hospital_centres, :abbrev, unique: true
    end
  end
end
