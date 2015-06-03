class CreateBagTypes < ActiveRecord::Migration
  def change
    create_table :bag_types do |t|
      t.string :manufacturer
      t.string :description
      t.integer :amount_1_36_glucose
      t.integer :amount_2_27_glucose
      t.integer :amount_3_86_glucose
      t.integer :amount_amino_acid
      t.integer :amount_icodextrin_acid
      t.boolean :uses_low_gdp
      t.boolean :uses_low_sodium
      t.timestamps null: false
    end
  end
end
