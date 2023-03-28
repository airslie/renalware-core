class AddCodeToDrugsAndMedicationRoutes < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      within_renalware_schema do
        add_column :drugs, :code, :string
        add_index :drugs, :code, unique: true

        remove_index :medication_routes, :name

        # To keep the position of the legacy_code column in the column list,
        # should we instead copy the data over to a new column?
        rename_column :medication_routes, :code, :legacy_code
        remove_index :medication_routes, :legacy_code
        change_column_null :medication_routes, :legacy_code, true

        add_column :medication_routes, :code, :string
        add_index :medication_routes, :code, unique: true
      end
    end
  end
end
