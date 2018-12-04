class AddCodeToHospitalsWards < ActiveRecord::Migration[5.1]
  def change
    within_renalware_schema do
      add_column :hospital_wards, :code, :string, index: true
    end
  end
end
