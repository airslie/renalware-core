def find_param_id(row)
  case row["type"].demodulize
    when "ObservationResult" then
      Renalware::Pathology::ObservationDescription.find_by!(code: row["param_id"]).id
    when "RequestResult" then
      Renalware::Pathology::RequestDescription.find_by!(code: row["param_id"]).id
    when "PrescriptionDrug" then
      Renalware::Drugs::Drug.find_by!(name: row["param_id"]).id
    when "PrescriptionDrugType" then
      Renalware::Drugs::Type.find_by!(name: row["param_id"]).id
    when "PrescriptionDrugCategory" then
      Renalware::Pathology::Requests::DrugCategory.find_by(name: row["param_id"]).id
  end
end

module Renalware
  log '--------------------Adding Pathology Request Algorithm Global Rules --------------------'

  file_path = File.join(File.dirname(__FILE__), 'request_algorithm_global_rules.csv')

  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Pathology::Requests::GlobalRule.find_or_create_by!(
      rule_set_id: row["rule_set_id"],
      rule_set_type: "Renalware::Pathology::Requests::GlobalRuleSet",
      type: row["type"],
      param_id: find_param_id(row),
      param_comparison_operator: row["param_comparison_operator"],
      param_comparison_value: row["param_comparison_value"]
    )
  end

  log "#{logcount} Global Rules seeded"
end
