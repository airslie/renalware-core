class CreateHDPatientStatistics < ActiveRecord::Migration
  def change
    create_table :hd_patient_statistics do |t|
      t.belongs_to :patient, null: false, index: true, foreign_key: true
      t.belongs_to :hospital_unit, index: true, null: false, foreign_key: true

      t.integer :month, index: true, null: false # 0 = rolling
      t.integer :year, index: true, null: false  # 0 = rolling

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

    # A patient can only have one row per month and one rolling row (month and year = 0)
    add_index :hd_patient_statistics, [:patient_id, :month, :year], unique: true
  end
end
