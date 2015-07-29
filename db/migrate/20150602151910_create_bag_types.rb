class CreateBagTypes < ActiveRecord::Migration
  def change
    create_table :bag_types do |t|
      t.string :manufacturer
      t.string :description
      t.decimal :glucose_grams_per_litre, precision: 4, scale: 1
      t.boolean :amino_acid
      t.boolean :icodextrin
      t.boolean :low_glucose_degradation
      t.boolean :low_sodium
      t.integer :sodium_content
      t.integer :lactate_content
      t.decimal :calcium_content, precision: 3, scale: 2
      t.decimal :magnesium_content, precision: 3, scale: 2
      t.datetime :deleted_at
      t.timestamps null: false
    end
    add_index :bag_types, :deleted_at
  end
end
