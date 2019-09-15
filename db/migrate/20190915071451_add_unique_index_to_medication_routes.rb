class AddUniqueIndexToMedicationRoutes < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_index :medication_routes, :code, unique: true
      add_index :medication_routes, :name, unique: true
    end
  end
end
