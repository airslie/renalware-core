class RenameRequestAlgorithmToRequests < ActiveRecord::Migration
  def change
    rename_table :pathology_request_algorithm_global_rules, :pathology_requests_global_rules
    rename_table :pathology_request_algorithm_global_rule_sets, :pathology_requests_global_rule_sets
    rename_table :pathology_request_algorithm_patient_rules, :pathology_requests_patient_rules
  end
end
