Given(/^Clyde is on Patty's clinic visits index$/) do
  visit patient_clinic_visits_path(@patty)
end

Given(/^Clyde is on Patty's edit clinic visit page$/) do
  visit edit_patient_clinic_visit_path(
    patient_id: @patty.id,
    id: @clinic_visit.id
  )
end

Given(/^Clinics$/) do |clinics|
  clinics.hashes.each do |clinic_params|
    create_clinic(clinic_params)
  end
end

Given(/^Patty has a clinic visit$/) do
  @clinic_visit = create_clinic_visit(@patty, @clyde)
end

When(/^Clyde chooses to add a clinic visit$/) do
  click_on "Add clinic visit"
end

When(/^records Patty's clinic visit$/) do
  @clinic_visit = record_clinic_visit(@patty, @clyde)
end

When(/^Clyde updates Patty's clinic visit$/) do
  update_clinic_visit(@clinic_visit)
end

Then(/^Patty's clinic visit should exist$/) do
  expect_clinic_visit_to_exist(@patty)
end

Then(/^Patty's clinic visit should be updated$/) do
  expect_clinic_visit_to_be_updated(@clinic_visit)
end
