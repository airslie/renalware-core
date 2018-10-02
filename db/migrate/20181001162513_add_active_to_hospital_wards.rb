class AddActiveToHospitalWards < ActiveRecord::Migration[5.1]
  def change
    add_column :hospital_wards, :active, :boolean, default: true, null: false
  end
end
