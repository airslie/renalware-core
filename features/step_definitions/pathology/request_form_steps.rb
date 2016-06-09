When(/^Clyde generates a request form with the following:$/) do |table|
  @request_forms = generate_pathology_request_forms(@clyde, table.rows_hash.with_indifferent_access)
end

Then(/^Clyde sees these details at the top of the form$/) do |table|
  expect_patient_summary_to_match_table(@request_forms, @patty, table)
end

Then(/^Clyde sees this patient specific test: (.*)$/) do |test_description|
  expect_patient_specific_test(@request_forms, @patty, test_description)
end

Then(/^Clyde sees no global tests required$/) do
  expect_no_request_descriptions_required(@request_forms, @patty)
end

Then(/^Clyde sees the request description ([A-Z0-9]+) required$/) do |request_description_code|
  expect_request_description_required(@request_forms, @patty, request_description_code)
end
