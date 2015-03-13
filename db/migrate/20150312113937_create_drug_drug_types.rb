class CreateDrugDrugTypes < ActiveRecord::Migration
  def change
    create_table :drug_drug_types do |t|
      t.integer :drug_id
      t.integer :drug_type_id
      t.timestamps null: false
    end
    add_index(:drug_drug_types, [:drug_id, :drug_type_id], unique: true)
  end
end
