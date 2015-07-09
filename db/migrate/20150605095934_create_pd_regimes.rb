class CreatePdRegimes < ActiveRecord::Migration
  def change
    create_table :pd_regimes do |t|
      t.integer :patient_id
      t.date :start_date
      t.date :end_date
      t.string :type
      t.integer :glucose_ml_percent_1_36
      t.integer :glucose_ml_percent_2_27
      t.integer :glucose_ml_percent_3_86
      t.integer :amino_acid_ml
      t.integer :icodextrin_ml
      t.boolean :low_glucose_degradation
      t.boolean :low_sodium
      t.boolean :additional_hd
      t.timestamps null: false
    end
  end
end
