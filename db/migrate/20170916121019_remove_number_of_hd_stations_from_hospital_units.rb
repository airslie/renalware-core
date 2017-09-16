class RemoveNumberOfHDStationsFromHospitalUnits < ActiveRecord::Migration[5.1]
  def change
    remove_column :hospital_units, :number_of_hd_stations, :integer
  end
end
