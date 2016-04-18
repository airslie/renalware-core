class CreatePathologyRequestAlgorithmGlobalRules < ActiveRecord::Migration
  def change
    create_table :pathology_request_algorithm_global_rules do |t|
      t.integer :observation_description_id, null: false
      t.string :regime, null: false
      t.string :param_type
      t.string :param_id
      t.string :param_comparison_operator
      t.string :param_comparison_value
      t.datetime :frequency
    end
  end
end
