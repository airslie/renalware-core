Given(/^Patty has a recipient workup$/) do
  set_up_recipient_workup_for(@patty)
end

Given(/^Don has a donor workup$/) do
  set_up_doner_workup_for(@don)
end

Given(/^Patty is registered on the wait list$/) do
  set_up_patient_on_wait_list(@patty)
end

Given(/^Patty is registered on the wait list with this status history$/) do |table|
  set_up_patient_wait_list_statuses(@patty, table)
end

Given(/^Patty has a recipient operation$/) do
  set_up_recipient_operation(@patty)
end

Given(/^Don has a donor operation$/) do
  set_up_donor_operation(@don)
end

Given(/^Don has a donation$/) do
  set_up_donation(@don)
end

# WHEN

When(/^Clyde creates a donor workup for Don$/) do
  create_donor_workup(patient: @don, user: @clyde)
end

When(/^Clyde creates a recipient workup for Patty$/) do
  create_recipient_workup(patient: @patty, user: @clyde)
end

When(/^Clyde updates the assessment$/) do
  update_workup(patient: @patty, user: @clyde)
end

When(/^Clyde updates the donor assessment$/) do
  update_donor_workup(patient: @don, user: @clyde)
end

When(/^Clyde registers Patty on the wait list with status "(.*?)" starting on "(.*?)"$/) \
  do |status, started_on|
  create_transplant_registration(
    patient: @patty,
    status: status, started_on: started_on,
    user: @clyde
  )
end

When(/^Clyde records a recipient operation for Patty$/) do
  create_recipient_operation(
    patient: @patty,
    user: @clyde,
    performed_on: Time.zone.today
  )
end

When(/^Clyde records a donation for Don$/) do
  create_donation(
    patient: @don,
    user: @clyde,
    state: "volunteered"
  )
end

When(/^Clyde submits an erroneous donation$/) do
  create_donation(
    patient: @don,
    user: @clyde,
    state: "invalid_state"
  )
end

When(/^Clyde records a donor operation for Don$/) do
  create_donor_operation(
    patient: @don,
    user: @clyde,
    performed_on: Time.zone.today
  )
end

When(/^Clyde submits an erroneous registration$/) do
  create_transplant_registration(
    patient: @patty,
    status: "Died", started_on: "99-99-9999",
    user: @clyde
  )
end

When(/^Clyde submits an erroneous recipient operation$/) do
  create_recipient_operation(
    patient: @patty,
    user: @clyde,
    performed_on: ""
  )
end

When(/^Clyde submits an erroneous donor operation$/) do
  create_donor_operation(
    patient: @don,
    user: @clyde,
    performed_on: ""
  )
end

When(/^Clyde submits a pre\-dated registration$/) do
  create_transplant_registration(
    patient: @patty,
    status: "Died", started_on: Time.zone.today + 1.day,
    user: @clyde
  )
end

When(/^Clyde sets the registration status to "(.*?)" and the start date to "(.*?)"$/) \
  do |status, started_on|
  set_transplant_registration_status(
    patient: @patty,
    status: status, started_on: started_on,
    user: @clyde
  )
end

When(/^Clyde submits an erroneous registration status$/) do
  set_transplant_registration_status(
    patient: @patty,
    status: "Active", started_on: "",
    user: @clyde
  )
end

When(/^Clyde submits an pre\-dated registration status$/) do
  set_transplant_registration_status(
    patient: @patty,
    status: "Active", started_on: (Time.zone.today + 1.day),
    user: @clyde
  )
end

When(/^Clyde changes the "(.*?)" start date to "(.*?)"$/) do |status, started_on|
  update_transplant_registration_status(
    patient: @patty,
    status: status, started_on: started_on,
    user: @clyde
  )
end

When(/^Clyde deletes the "(.*?)" status change$/) do |status|
  delete_transplant_registration_status(
    patient: @patty,
    status: status,
    user: @clyde
  )
end

When(/^Clyde assigns Patty as a recipient for Don's donation$/) do
  assign_recipient_to_donation(
    patient: @don,
    recipient: @patty,
    user: @clyde
  )
end

# THEN

Then(/^Patty's recipient workup exists$/) do
  expect_recipient_workup_to_exist(@patty)
end

Then(/^Patty's recipient workup gets updated$/) do
  expect_workup_to_be_modified(@patty)
end
Then(/^Don's donor workup exists$/) do
  expect_donor_workup_to_exist(@don)
end

Then(/^Don's donor workup gets updated$/) do
  expect_donor_workup_to_be_modified(@don)
end

Then(/^Patty has an active transplant registration since "(.*?)"$/) do |started_on|
  expect_transplant_registration_to_exist(
    patient: @patty, status_name: "Active", started_on: started_on
  )
end

Then(/^Patty has a new recipient operation$/) do
  expect_recipient_operation_to_exist(@patty)
end

Then(/^Don has a new donor operation$/) do
  expect_donor_operation_to_exist(@don)
end

Then(/^Don has a new donation$/) do
  expect_donation_to_exist(@don)
end

Then(/^the registration is not accepted$/) do
  expect_transplant_registration_to_be_refused
end

Then(/^Clyde can update Patty's transplant registration$/) do
  expect_transplant_registration_to_be_modified(patient: @patty)
end

Then(/^Clyde can update Patty's recipient operation$/) do
  expect_update_recipient_operation_to_succeed(patient: @patty, user: @clyde)
end

Then(/^Clyde can update Don's donor operation$/) do
  expect_update_donor_operation_to_succeed(patient: @don, user: @clyde)
end

Then(/^Clyde can update Don's donation$/) do
  expect_update_donation_to_succeed(patient: @don, user: @clyde)
end

Then(/^the registration status history is$/) do |table|
  expect_transplant_registration_status_history_to_match(patient: @patty, hashes: table.hashes)
end

Then(/^the registration status is not accepted$/) do
  expect_transplant_registration_status_to_be_refused(@patty)
end

Then(/^the recipient operation is not accepted$/) do
  expect_recipient_operation_to_be_refused
end

Then(/^the donor operation is not accepted$/) do
  expect_donor_operation_to_be_refused
end

Then(/^the donation is not accepted$/) do
  expect_donation_to_be_refused
end

Then(/^the donation has Patty as a recipient$/) do
  expect_transplant_donation_as_recipient(patient: @don, recipient: @patty)
end

Then(/^the transplant current status stays "(.*?)" since "(.*?)"$/) do |name, start_date|
  expect_transplant_registration_current_status_to_be(patient: @patty,
    name: name, started_on: start_date)
end

Then(/^the status history has the following revised termination dates$/) do |table|
  expect_transplant_registration_status_history_to_include(patient: @patty, hashes: table.hashes)
end

Then(/^the status history has the following revised statuses$/) do |table|
  expect_transplant_registration_status_history_to_include(patient: @patty, hashes: table.hashes)
end

Then(/^the current status was set by Clyde$/) do
  expect_transplant_registration_current_status_by_to_be(patient: @patty, user: @clyde)
end