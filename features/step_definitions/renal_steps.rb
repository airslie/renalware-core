When(/^Donna reviews Patty's clinical summary$/) do
  @clinical_summary = review_clinical_summary(patient: @patty, user: @donna)
end

Then(/^Donna should see these current prescriptions in the clinical summary$/) do |table|
  expect_current_prescriptions_to_match(@clinical_summary.current_prescriptions, table.hashes)
end

Then(/^Donna should see these current problems in the clinical summary:$/) do |table|
  expect_problems_to_match_table(@clinical_summary.current_problems, table)
end
