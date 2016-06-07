When(/^Clyde enters clinic (.*)$/) do |clinic_name|
  clinic = Renalware::Clinics::Clinic.find_by!(name: clinic_name)
  @url_params = set_url_params(@url_params, clinic_id: clinic.id)
end

When(/^Clyde enters doctor ([A-Za-z]+) ([A-Za-z]+)$/) do |given_name, family_name|
  doctor = Renalware::Doctor.find_by!(given_name: given_name, family_name: family_name)
  @url_params = set_url_params(@url_params, doctor_id: doctor.id)
end

When(/^Clyde enters telephone number (\d*)$/) do |telephone|
  @url_params = set_url_params(@url_params, telephone: telephone)
end

When(/^Clyde views the pathology request form for Patty$/) do
  get_pathology_request_form(@clyde, @url_params, @patty.id)
end

Then(/^Clyde sees these details at the top of the form$/) do |table|
  expect_patient_summary_to_match_table(@patty.id, table)
end

Then(/^Clyde sees this patient specific test: (.*)$/) do |string|
  expect(page).to have_content(string)
end

Then(/^Clyde sees no global tests required$/) do
  expect(page).to have_content("No tests required.")
end

Then(/^Clyde sees the request description ([A-Z0-9]+) required$/) do |request_description_code|
  expect_request_description_required(request_description_code)
end
