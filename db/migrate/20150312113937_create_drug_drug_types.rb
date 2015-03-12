class CreateDrugDrugTypes < ActiveRecord::Migration
  def change
    create_table :drug_drug_types do |t|
      t.integer :drug_id
      t.integer :drug_type_id
      t.timestamps null: false
    end
  end
end
