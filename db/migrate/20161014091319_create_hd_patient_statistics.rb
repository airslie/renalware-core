class CreateHDPatientStatistics < ActiveRecord::Migration
  def change
    create_table :hd_patient_statistics do |t|
      t.references :patient, null: false, foreign_key: true, index: true

      t.date :period_start, null: false, index: true
      t.date :period_end, null: true, index: true

      t.decimal :float_value, precision: 10, scale: 2
      t.decimal :pre_mean_systolic_blood_pressure, precision: 10, scale: 2
      t.decimal :pre_mean_diastolic_blood_pressure, precision: 10, scale: 2
      t.decimal :post_mean_systolic_blood_pressure, precision: 10, scale: 2
      t.decimal :post_mean_diastolic_blood_pressure, precision: 10, scale: 2
      t.decimal :lowest_systolic_blood_pressure, precision: 10, scale: 2
      t.decimal :highest_systolic_blood_pressure, precision: 10, scale: 2
      t.decimal :mean_fluid_removal, precision: 10, scale: 2
      t.decimal :mean_weight_loss, precision: 10, scale: 2
      t.decimal :mean_machine_ktv, precision: 10, scale: 2
      t.decimal :mean_blood_flow, precision: 10, scale: 2
      t.decimal :mean_litres_processed, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
