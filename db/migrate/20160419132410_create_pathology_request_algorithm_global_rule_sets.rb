class CreatePathologyRequestAlgorithmGlobalRuleSets < ActiveRecord::Migration
  def change
    create_table :pathology_request_algorithm_global_rule_sets do |t|
      t.string :regime, null: false
      t.integer :observation_description_id, null: false
      t.string :frequency, null: false
    end
  end
end
