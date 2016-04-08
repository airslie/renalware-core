Given(/^Clyde is on Patty's clinic visits index$/) do
  visit patient_clinic_visits_path(@patty)
end

Given(/^Clinics$/) do |clinics|
  clinics.hashes.each do |clinic_params|
    create_clinic(clinic_params)
  end
end

When(/^Clyde chooses to add a clinic visit$/) do
  click_on "Add clinic visit"
end

When(/^records Patty's clinic visit$/) do
  record_clinic_visit
end

Then(/^Patty's clinic visit should exist$/) do
  expect_clinic_visit_to_exist(@patty)
end