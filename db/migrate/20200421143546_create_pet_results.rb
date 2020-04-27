class CreatePETResults < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_enum :pd_pet_type, %w(full fast)

      create_table :pd_pet_results do |t|
        t.references :patient, null: false, foreign_key: true

        # The first set are inputs after seeing the patient
        t.date :performed_on, null: false
        t.enum :test_type, enum_name: :pd_pet_type, null: false
        t.integer :volume_in
        t.integer :volume_out
        t.decimal :dextrose, scale: 2, precision: 15
        t.integer :infusion_time
        t.integer :drain_time
        t.decimal :overnight_volume_in, scale: 2, precision: 15
        t.decimal :overnight_volume_out, scale: 2, precision: 15
        t.decimal :overnight_dextrose, scale: 2, precision: 15
        t.integer :overnight_dwell_time

        # This set is manually or automatically added pathology after the fact
        [0, 2, 3, 6].each do |hr|
          t.decimal :"sample_#{hr}hr_time", scale: 2, precision: 6 # Ask sf
          t.decimal :"sample_#{hr}hr_urea", scale: 2, precision: 15
          t.decimal :"sample_#{hr}hr_creatinine", scale: 2, precision: 15
          t.decimal :"sample_#{hr}hr_glc", scale: 2, precision: 15
          t.decimal :"sample_#{hr}hr_sodium", scale: 2, precision: 15
          t.decimal :"sample_#{hr}hr_protein", scale: 2, precision: 15
        end

        # This set is for calculated fields
        t.decimal :netUF, scale: 2, precision: 8
        t.decimal :D_Pcr, scale: 2, precision: 8

        t.references :created_by, index: true, null: false
        t.references :updated_by, index: true, null: false

        t.timestamps null: false
      end

      add_foreign_key :pd_pet_results, :users, column: :created_by_id
      add_foreign_key :pd_pet_results, :users, column: :updated_by_id
    end
  end
end
