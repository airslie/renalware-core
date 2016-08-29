Given(/^the high risk rule set contains these rules:$/) do |table|
  table.hashes.each do |params|
    create_global_rule(
      params.merge("rule_set_type" => "Renalware::Pathology::Requests::HighRiskRuleSet")
    )
  end
end

When(/^the high risk algorithm is run for Patty$/) do
  @high_risk = run_high_risk_algorithm(@patty)
end

Then(/^Patty is determined to be high risk$/) do
  expect(@high_risk).to be_truthy
end

Then(/^Patty is determined not to be high risk$/) do
  expect(@high_risk).to be_falsey
end
