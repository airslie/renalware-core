class CreateIndexOnLowerPatientFamilyName < ActiveRecord::Migration[5.1]
  def change
    add_index :patients,
            "lower(family_name), given_name",
            name: "idx_patients_on_lower_family_name"
  end
end
