class RenamePathologyRequestsGlobalRuleParamTypeToType < ActiveRecord::Migration[4.2]
  def change
    rename_column :pathology_requests_global_rules, :param_type, :type
  end
end
