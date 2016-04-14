class CreatePathologyRequestAlgorithmRules < ActiveRecord::Migration
  def change
    create_table :pathology_request_algorithm_global_rules do |t|
      t.string :request, null: false
      t.string :regime, null: false
      t.string :param_type
      t.string :param_identifier
      t.string :param_comparison_value
      t.datetime :frequency
    end
  end
end
