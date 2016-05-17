module Renalware
  log '--------------------Adding Pathology Request Algorithm Global Rules --------------------'

  file_path = File.join(demo_path, 'pathology_request_algorithm_global_rules.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::RequestAlgorithm::GlobalRule.find_or_create_by!(
      global_rule_set_id: row["global_rule_set_id"],
      param_type: row["param_type"],
      param_id: row["param_id"],
      param_comparison_operator: row["param_comparison_operator"],
      param_comparison_value: row["param_comparison_value"]
    )
  end

  log "#{logcount} Global Rules seeded"
end
