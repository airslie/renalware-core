class CreateBagTypes < ActiveRecord::Migration
  def change
    create_table :bag_types do |t|
      t.string :manufacturer
      t.string :description
      t.integer :glucose_ml_percent_1_36
      t.integer :glucose_ml_percent_2_27
      t.integer :glucose_ml_percent_3_86
      t.integer :amino_acid_ml
      t.integer :icodextrin_acid_ml
      t.boolean :low_glucose_degradation
      t.boolean :low_sodium
      t.datetime :deleted_at
      t.timestamps null: false
    end
    add_index :bag_types, :deleted_at
  end
end
