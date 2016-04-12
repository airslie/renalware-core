class CreatePathologyRequestAlgorithmRules < ActiveRecord::Migration
  def change
    create_table :pathology_request_algorithm_rules do |t|
      t.string :request, null: false
      t.string :group, null: false
      t.string :param_type
      t.string :param_identifier
      t.string :param_value
      t.datetime :frequency
    end
  end
end
