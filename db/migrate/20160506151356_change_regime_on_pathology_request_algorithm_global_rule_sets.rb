class ChangeRegimeOnPathologyRequestAlgorithmGlobalRuleSets < ActiveRecord::Migration[4.2]
  def change
    remove_column :pathology_request_algorithm_global_rule_sets, :regime, :string, null: false
    add_column :pathology_request_algorithm_global_rule_sets, :clinic_id, :integer
    add_foreign_key :pathology_request_algorithm_global_rule_sets, :clinics
  end
end
