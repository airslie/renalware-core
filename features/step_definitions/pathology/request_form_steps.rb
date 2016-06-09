def get_patient(patient_name)
  instance_variable_get("@#{patient_name.downcase}".to_sym)
end

When(/^Clyde generates a set of request forms with the following:$/) do |table|
  @request_forms = generate_pathology_request_forms(@clyde, table.rows_hash.with_indifferent_access)
end

Then(/^Clyde sees these details at the top of (\w+)'s form$/) do |patient_name, table|
  patient = get_patient(patient_name)
  expect_patient_summary_to_match_table(@request_forms, patient, table)
end

Then(/^Clyde sees this patient specific test for (\w+): (.*)$/) do |patient_name, test_description|
  patient = get_patient(patient_name)
  expect_patient_specific_test(@request_forms, patient, test_description)
end

Then(/^Clyde does not see the request description ([A-Z0-9]+) required for (\w+)$/) do |request_description_code, patient_name|
  patient = get_patient(patient_name)
  expect_request_description_not_required(@request_forms, patient, request_description_code)
end

Then(/^Clyde sees the request description ([A-Z0-9]+) required for (\w+)$/) do |request_description_code, patient_name|
  patient = get_patient(patient_name)
  expect_request_description_required(@request_forms, patient, request_description_code)
end
