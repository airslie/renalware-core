class AddODSCodeToHospitalUnits < ActiveRecord::Migration[7.1]
  def change
    within_renalware_schema do
      add_column :hospital_units, :ods_code, :string
    end
  end
end
