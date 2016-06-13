When(/^Clyde generates a set of request forms with the following:$/) do |table|
  @request_forms = generate_pathology_request_forms(@clyde, table.rows_hash.with_indifferent_access)
end

Then(/^Clyde sees these details at the top of (\w+)'s form$/) do |patient_name, table|
  patient = get_patient(patient_name)
  expect_patient_summary_to_match_table(@request_forms, patient, table)
end

Then(/^Clyde sees the following pathology requirements for (\w+):$/) do |patient_name, table|
  patient = get_patient(patient_name)
  expect_pathology_form(@request_forms, patient, table.rows_hash)
end
