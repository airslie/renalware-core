class RenameFrequencyToFrequencyTypeOnPathologyRequestAlgorithmGlobalRuleSets < ActiveRecord::Migration
  def change
    rename_column :pathology_request_algorithm_global_rule_sets, :frequency, :frequency_type
  end
end
