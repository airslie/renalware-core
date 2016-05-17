class ChangePatientRulesLastTestAt < ActiveRecord::Migration
  def change
    rename_column :pathology_request_algorithm_patient_rules, :last_tested_at, :last_observed_at
  end
end
