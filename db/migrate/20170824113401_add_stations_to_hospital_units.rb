class AddStationsToHospitalUnits < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_units,
               :number_of_hd_stations,
               :integer,
               index: true
  end
end
