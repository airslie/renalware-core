# Rule: Given steps should not go through the UI, no matter what the world is
Given(/^the transplants module is configured$/) do
  ["Active", "Transplanted", "Waiting"].each do |name|
    Renalware::Transplants::RegistrationStatusDescription.create!(name: name)
  end
end

Given(/^Patty has a recipient workup$/) do
  @workup = Renalware::Transplants::RecipientWorkup.create!(
    patient: @patty
  )
end

Given(/^Don has a donor workup$/) do
  @workup = Renalware::Transplants::DonorWorkup.create!(
    patient: @don,
    document: {
      relationship: {
        donor_recip_relationship: "son_or_daughter"
      }
    }
  )
end

Given(/^Patty is registered on the wait list$/) do
  @registration = Renalware::Transplants::Registration.create!(
    patient: @patty,
    statuses_attributes: {
      "0": {
        started_on: "03-11-2015",
        description_id: 1
      }
    }
  )
end

Given(/^Patty is registered on the wait list with this status history$/) do |table|
  @registration = Renalware::Transplants::Registration.create!(
    patient: @patty
  )
  table.hashes.each do |row|
    description = registration_status_description_named(row[:status])
    @registration.statuses.create!(
      description: description,
      started_on: row[:start_date],
      terminated_on: row[:termination_date]
    )
  end
  @initial_statuses_count = @registration.statuses.count
end

When(/^Clyde creates a donor workup for Don$/) do
  create_donor_workup(user: @clyde, patient: @don)
end

When(/^Clyde creates a recipient workup for Patty$/) do
  create_recipient_workup(user: @clyde, patient: @patty)
end

When(/^Clyde updates the assessment$/) do
  travel_to 1.hour.from_now
  update_workup(workup: @workup, user: @clyde, updated_at: Time.zone.now)
end

When(/^Clyde updates the donor assessment$/) do
  travel_to 1.hour.from_now
  update_donor_workup(workup: @workup, user: @clyde, updated_at: Time.zone.now)
end

When(/^Clyde registers Patty on the wait list with status "(.*?)" starting on "(.*?)"$/) do |status, started_on|
  create_transplant_registration(
    user: @clyde, patient: @patty,
    status: status, started_on: started_on
  )
end

When(/^Clyde submits an erroneous registration$/) do
  create_transplant_registration(
    user: @clyde, patient: @patty,
    status: "boom", started_on: "99-99-9999"
  )
end

When(/^Clyde sets the registration status to "(.*?)" and the start date to "(.*?)"$/) do |status, started_on|
  set_transplant_registration_status(registration: @registration, user: @clyde,
    status: status, started_on: started_on)
end

When(/^Clyde submits an erroneous registration status$/) do
  set_transplant_registration_status(registration: @registration, user: @clyde,
    status: "Active", started_on: "")
end

When(/^Clyde changes the "(.*?)" start date to "(.*?)"$/) do |status, started_on|
  update_transplant_registration_status(registration: @registration, user: @clyde,
    status: status, started_on: started_on)
end

When(/^Clyde deletes the "(.*?)" status change$/) do |status|
  delete_transplant_registration_status(registration: @registration, user: @clyde,
    status: status)
end

Then(/^Patty's recipient workup exists$/) do
  expect(recipient_workup_exists(@patty)).to be_truthy
end

Then(/^Patty's recipient workup gets updated$/) do
  expect(workup_was_updated(@patty)).to be_truthy
end

Then(/^Don's donor workup exists$/) do
  expect(donor_workup_exists(@don)).to be_truthy
end

Then(/^Don's donor workup gets updated$/) do
  expect(donor_workup_was_updated(@don)).to be_truthy
end

Then(/^Patty has an active transplant registration since "(.*?)"$/) do |started_on|
  transplant_registration_exists(patient: @patty, status_name: "Active", started_on: started_on)
end

Then(/^the registration is not accepted by the system$/) do
  transplant_registration_was_refused
end

Then(/^Clyde is notified of the registration errors$/) do
  transplant_registration_has_errors
end

Then(/^Clyde can update Patty's transplant registration$/) do
  expect(update_transplant_registration(
    registration: @registration, user: @clyde,
    updated_at: Time.zone.now)
  ).to be_truthy
end

Then(/^the registration status history is$/) do |table|
  transplant_registration_status_history_matches(registration: @registration, hashes: table.hashes)
end

Then(/^the registration status is not accepted by the system$/) do
  transplant_registration_status_was_refused
end

Then(/^Clyde is notified of the registration status errors$/) do
  transplant_registration_status_has_errors
end

Then(/^the transplant current status stays "(.*?)" since "(.*?)"$/) do |name, start_date|
  transplant_registration_current_status_is(registration: @registration,
    name: name, started_on: start_date)
end

Then(/^the status history has the following revised termination dates$/) do |table|
  transplant_registration_status_history_includes(registration: @registration, hashes: table.hashes)
end