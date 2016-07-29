Given(/^Patty has a request form generated with parameters:$/) do |table|
  params = table.rows_hash
  pathology_patient = Renalware::Pathology.cast_patient(@patty)

  @request_forms = generate_request_forms_for_single_patient(@clyde,
    clinic: params[:clinic],
    consultant: params[:consultant],
    telephone: params[:telephone],
    patients: [pathology_patient]
  )
end

When(/^Clyde chooses the consultant (\w+\s\w+)$/) do |user_name|
  @request_forms = update_request_form_user(user_name)
end

When(/^Clyde chooses the clinic (\w+)$/) do |clinic_name|
  @request_forms = update_request_form_clinic(clinic_name)
end

When(/^Clyde chooses the telephone number (\d+)$/) do |telephone|
  @request_forms = update_request_form_telephone(telephone)
end

When(/^Clyde generates the request forms for the appointments with the following parameters:$/) do |table|
  params = Hash[table.rows].with_indifferent_access

  @appointments = view_appointments(@clyde)
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments, params)
end

When(/^Clyde generates the request forms for the appointments sorted by user with the following parameters:$/) do |table|
  params = Hash[table.rows].with_indifferent_access

  @appointments = view_appointments(@clyde, q: { s: "user_family_name asc" })
  @request_forms = generate_request_forms_for_appointments(@clyde, @appointments, params)
end

When(/^Clyde generates the request form for (\w+) with the following parameters:$/) do |patient_name, table|
  params =
    Hash[table.rows]
      .merge(patients: [patient_name])
      .with_indifferent_access

  @request_forms = generate_request_forms_for_single_patient(@clyde, params)
end

When(/^Clyde prints Patty's request form$/) do
  @request_forms.each { |request_form| request_form.save }
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
  patients = table.rows.map do |patient_full_name, _user_full_name|
    given_name, family_name = patient_full_name.split(" ")
    Renalware::Pathology::Patient.find_by(given_name: given_name, family_name: family_name)
  end

  expect_pathology_forms_for_patients(@request_forms, patients)
end

Then(/^Patty has the request recorded:$/) do |table|
  params = table.rows_hash

  patient = Renalware::Pathology.cast_patient(@patty)
  clinic = find_requested_clinic(params[:clinic])
  consultant = find_or_create_requested_consultant(params[:consultant])

  request_descriptions = params[:request_descriptions].split(", ").map do |request_description_code|
    Renalware::Pathology::RequestDescription.find_or_create_by(code: request_description_code)
  end
  patient_rules = params[:patient_rules].split(", ").map do |test_description|
    Renalware::Pathology::Requests::PatientRule.find_or_create_by(test_description: test_description)
  end

  request =
    Renalware::Pathology::Requests::Request
    .includes(:request_descriptions, :patient_rules)
    .where(
      patient: patient,
      clinic: clinic,
      consultant: consultant,
      pathology_request_descriptions: { id: request_descriptions.map(&:id) },
      pathology_requests_patient_rules: { id: patient_rules.map(&:id) }
    )

  expect(request).to be_exist
end
