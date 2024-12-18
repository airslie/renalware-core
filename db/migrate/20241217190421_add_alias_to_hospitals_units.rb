class AddAliasToHospitalsUnits < ActiveRecord::Migration[7.2]
  def change
    within_renalware_schema do
      safety_assured do
        add_column :hospital_units, :alias, :string
        add_index :hospital_units, :alias, unique: true
      end
    end
  end
end
