class CreateDrugTypesDrugs < ActiveRecord::Migration
  def change
    create_table :drug_types_drugs, id: false do |t|
      t.integer :drug_id
      t.integer :drug_type_id
      t.timestamps null: false
    end
    add_index(:drug_types_drugs, [:drug_id, :drug_type_id], unique: true)
  end
end
