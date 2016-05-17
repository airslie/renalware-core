class CreatePathologyRequestAlgorithmPatientRules < ActiveRecord::Migration
  def change
    create_table :pathology_request_algorithm_patient_rules do |t|
      t.string :lab
      t.text :test_description
      t.integer :sample_number_bottles
      t.string :sample_type
      t.string :frequency
      t.integer :patient_id
      t.datetime :last_tested_at
      t.date :start_date
      t.date :end_date
    end
    add_foreign_key :pathology_request_algorithm_patient_rules, :patients
  end
end
