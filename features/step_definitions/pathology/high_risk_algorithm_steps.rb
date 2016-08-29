Given(/^the high risk rule set contains these rules:$/) do |table|
  table.hashes.each do |params|
    create_global_rule(
      params.merge("rule_set_type" => "Renalware::Pathology::Requests::HighRiskRuleSet")
    )
  end
end

When(/^the high risk algorithm is run for Patty$/) do
  pathology_patty = Renalware::Pathology.cast_patient(@patty)
  @high_risk = Renalware::Pathology::Requests::HighRiskAlgorithm.new(pathology_patty).patient_is_high_risk?
end

Then(/^Patty is determined to be high risk$/) do
  expect(@high_risk).to be_truthy
end

Then(/^Patty is determined not to be high risk$/) do
  expect(@high_risk).to be_falsey
end
