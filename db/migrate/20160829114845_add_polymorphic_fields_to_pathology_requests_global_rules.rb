class AddPolymorphicFieldsToPathologyRequestsGlobalRules < ActiveRecord::Migration
  def change
    rename_column :pathology_requests_global_rules, :global_rule_set_id, :rule_set_id
    add_column :pathology_requests_global_rules, :rule_set_type, :string, null: false
  end
end
