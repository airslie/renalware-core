class CreatePdRegimes < ActiveRecord::Migration
  def change
    create_table :pd_regimes do |t|
      t.integer :user_id
      t.integer :patient_id
      t.date :start_date
      t.date :end_date
      t.integer :pd_treatment_regime_id
      t.integer :glucose_ml_percent_1_36
      t.integer :glucose_ml_percent_2_27
      t.integer :glucose_ml_percent_3_86
      t.integer :amino_acid_ml
      t.integer :icodextrin_ml
      t.string :low_glucose_degradation
      t.string :low_sodium
      t.integer :fluid_manufacturer
      t.string :additional_hd
      t.timestamps null: false
    end
  end
end
