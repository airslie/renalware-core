class MakeDrugTypesUnique < ActiveRecord::Migration[5.2]
  def change
    within_renalware_schema do
      add_index(:drug_types, :code, unique: true)
      add_index(:drug_types, :name, unique: true)
    end
  end
end
