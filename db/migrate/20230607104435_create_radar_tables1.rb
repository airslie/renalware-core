class CreateRaDaRTables1 < ActiveRecord::Migration[6.0]
  def change
    within_renalware_schema do
      create_table :problem_radar_cohorts do |t|
        t.string :name, null: false, index: { unique: true }
        t.timestamps null: false
      end

      create_table :problem_radar_diagnoses do |t|
        t.references :cohort, foreign_key: { to_table: "problem_radar_cohorts" }, null: false
        t.string :name, null: false
        t.timestamps null: false
      end

      add_index :problem_radar_diagnoses, [:cohort_id, :name], unique: true
    end
  end
end
