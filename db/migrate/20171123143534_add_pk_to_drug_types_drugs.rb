class AddPkToDrugTypesDrugs < ActiveRecord::Migration[5.1]
  def change

    # Remove the old PK
    reversible do |direction|
      direction.up { execute "ALTER TABLE drug_types_drugs DROP CONSTRAINT drug_types_drugs_pkey" }
      direction.down do
        # ok was on drug_type_id, which is incorrect (duplicates will be found) so leaving
      end
    end
    add_column :drug_types_drugs, :id, :primary_key
    add_index :drug_types_drugs, [:drug_id, :drug_type_id], unique: true
  end
end
