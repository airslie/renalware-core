class AddCodeToHospitalsWards < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_wards, :code, :string, index: true
  end
end
