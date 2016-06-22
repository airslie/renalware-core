When(/^Clyde chooses the consultant (\w+\s\w+)$/) do |user_name|
  @request_forms = update_request_form_user(user_name)
end

When(/^Clyde chooses the clinic (\w+)$/) do |clinic_name|
  @request_forms = update_request_form_clinic(clinic_name)
end

When(/^Clyde chooses the telephone number (\d+)$/) do |telephone|
  @request_forms = update_request_form_telephone(telephone)
end

When(/^Clyde generates the request form for (\w+)$/) do |patient_name|
  @request_forms = generate_request_forms_for_single_patient(@clyde, patients: [patient_name])
end

When(/^Clyde generates the request forms for the appointments$/) do
  @appointments = view_appointments(@clyde)
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments)
end

When(/^Clyde generates the request forms for the appointments sorted by user$/) do
  @appointments = view_appointments(@clyde, q: { s: "user_family_name asc" })
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments)
end

When(/^Clyde generates the request form for (\w+) with the following parameters:$/) do |patient_name, table|
  params =
    Hash[table.rows]
      .merge(patients: [patient_name])
      .with_indifferent_access

  @request_forms = generate_request_forms_for_single_patient(@clyde, params)
end

Then(/^Clyde sees these details at the top of (\w+)'s form$/) do |patient_name, table|
  patient = get_patient(patient_name)
  expect_patient_summary_to_match_table(@request_forms, patient, table)
end

Then(/^Clyde sees the following pathology requirements for (\w+):$/) do |patient_name, table|
  patient = get_patient(patient_name)
  expect_pathology_form(@request_forms, patient, table.rows_hash)
end

Then(/^Clyde sees the requests forms for these patients:$/) do |table|
  #byebug
  patients = table.rows.map do |patient_full_name, user_full_name|
    given_name, family_name = patient_full_name.split(" ")
    Renalware::Pathology::Patient.find_by(given_name: given_name, family_name: family_name)
  end

  expect_pathology_forms_for_patients(@request_forms, patients)
end
