Given(/^Patty has a request form generated:$/) do |table|
  params = table.rows_hash

  patient = Renalware::Pathology.cast_patient(@patty)
  clinic = Renalware::Clinics::Clinic.find_by!(name: params[:clinic])
  user = find_or_create_user(given_name: params[:consultant], role: :clinician)
  consultant = ActiveType.cast(user, ::Renalware::Pathology::Consultant)
  request_descriptions = params[:global_requests].split(", ").map do |request_description_name|
    Renalware::Pathology::RequestDescription.find_by(name: request_description_name)
  end
  patient_rules = params[:patient_requests].split(", ").map do |test_description|
    patient_rule = Renalware::Pathology::Requests::PatientRule.find_by(test_description: test_description)
  end

  @request_form = Renalware::Pathology::Requests::Request.new(
    patient: patient,
    clinic: clinic,
    consultant: consultant,
    telephone: params[:telephone],
    by: Renalware::SystemUser.find,
    request_descriptions: request_descriptions,
    #patient_rules: patient_rules
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
  @request_form.save
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
  clinic = Renalware::Clinics::Clinic.find_by!(name: params[:clinic])
  user = find_or_create_user(given_name: params[:consultant], role: :clinician)
  consultant = ActiveType.cast(user, ::Renalware::Pathology::Consultant)
  request_descriptions = params[:global_requests].split(", ").map do |request_description_name|
    Renalware::Pathology::RequestDescription.find_by(name: request_description_name)
  end
  patient_rules = params[:patient_requests].split(", ").map do |test_description|
    patient_rule = Renalware::Pathology::Requests::PatientRule.find_by(test_description: test_description)
  end

  request =
    Renalware::Pathology::Requests::Request
    .includes(:request_descriptions)
    .where(
      patient: patient,
      clinic: clinic,
      consultant: consultant,
      pathology_request_descriptions: { id: request_descriptions.map(&:id) }
    )

  expect(request).to be_exist
end
