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

When(/^Clyde submits an erroneous registration$/) do
  create_transplant_registration(
    patient: @patty,
    status: "Died", started_on: "99-99-9999",
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

# THEN

Then(/^Patty's recipient workup exists$/) do
  assert_recipient_workup_exists(@patty)
end

Then(/^Patty's recipient workup gets updated$/) do
  assert_workup_was_updated(@patty)
end

Then(/^Don's donor workup exists$/) do
  assert_donor_workup_exists(@don)
end

Then(/^Don's donor workup gets updated$/) do
  assert_donor_workup_was_updated(@don)
end

Then(/^Patty has an active transplant registration since "(.*?)"$/) do |started_on|
  assert_transplant_registration_exists(
    patient: @patty, status_name: "Active", started_on: started_on
  )
end

Then(/^the registration is not accepted$/) do
  assert_transplant_registration_was_refused
end

Then(/^Clyde can update Patty's transplant registration$/) do
  assert_update_transplant_registration(patient: @patty)
end

Then(/^the registration status history is$/) do |table|
  assert_transplant_registration_status_history_matches(patient: @patty, hashes: table.hashes)
end

Then(/^the registration status is not accepted$/) do
  assert_transplant_registration_status_was_refused(@patty)
end

Then(/^the transplant current status stays "(.*?)" since "(.*?)"$/) do |name, start_date|
  assert_transplant_registration_current_status_is(patient: @patty,
    name: name, started_on: start_date)
end

Then(/^the status history has the following revised termination dates$/) do |table|
  assert_transplant_registration_status_history_includes(patient: @patty, hashes: table.hashes)
end

Then(/^the status history has the following revised statuses$/) do |table|
  assert_transplant_registration_status_history_includes(patient: @patty, hashes: table.hashes)
end

Then(/^the current status was set by Clyde$/) do
  assert_transplant_registration_current_status_by(patient: @patty, user: @clyde)
end