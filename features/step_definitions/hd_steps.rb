Given(/^Patty has recorded HD preferences$/) do
  set_up_hd_preferences_for(@patty, user: @clyde)
end

Given(/^Patty has a recorded HD profile$/) do
  set_up_hd_profile_for(@patty, prescriber: Renalware::User.first)
end

Given(/^Patty has a recorded HD session$/) do
  set_up_hd_session_for(@patty, user: Renalware::User.first)
end

Given(/^Patty has a recorded dry weight entry$/) do
  set_up_hd_dry_weight_for(@patty, @clyde)
end

Given(/^These patients have these HD sessions$/) do |table|
  set_up_hd_sessions(table)
end


When(/^Clyde records the HD preferences of Patty$/) do
  create_hd_preferences(patient: @patty, user: @clyde)
end

When(/^Clyde records an HD profile for Patty$/) do
  create_hd_profile(patient: @patty, user: @clyde, prescriber: @clyde)
end

When(/^Clyde submits an erroneous HD profile$/) do
  create_hd_profile(patient: @patty, user: @clyde, prescriber: nil)
end

When(/^Nathalie records the pre\-session observations for Patty$/) do
  create_hd_session(patient: @patty, user: @nathalie, performed_on: Time.zone.today)
end

When(/^Clyde records the dry weight for Patty$/) do
  create_hd_dry_weight(patient: @patty, user: @clyde, assessed_on: Time.zone.today)
end

When(/^Nathalie submits an erroneous HD session$/) do
  create_hd_session(patient: @patty, user: @nathalie, performed_on: nil)
end

When(/^Clyde submits an erroneous dry weight$/) do
  create_hd_dry_weight(patient: @patty, user: @clyde, assessed_on: nil)
end

When(/^Clyde views the list of ongoing HD sessions$/) do
  view_ongoing_hd_sessions(user: @clyde)
end


Then(/^Patty has new HD preferences$/) do
  expect_hd_preferences_to_exist(@patty)
end

Then(/^Clyde can update Patty's HD preferences$/) do
  update_hd_preferences(patient: @patty, user: @clyde)
end

Then(/^Patty has a new HD profile$/) do
  expect_hd_profile_to_exist(@patty)
end

Then(/^Clyde can update Patty's HD profile$/) do
  update_hd_profile(patient: @patty, user: @clyde)
end

Then(/^the HD profile is not accepted$/) do
  expect_hd_profile_to_be_refused
end

Then(/^Patty has a new HD session$/) do
  expect_hd_session_to_exist(@patty)
end

Then(/^Nathalie can update Patty's HD session$/) do
  update_hd_session(patient: @patty, user: @nathalie)
end

Then(/^the HD session is not accepted$/) do
  expect_hd_session_to_be_refused
end

Then(/^Patty has a new dry weight$/) do
  expect_hd_dry_weight_to_exist(@patty)
end

Then(/^Clyde can update Patty's dry weight entry$/) do
  update_hd_dry_weight(patient: @patty, user: @clyde)
end

Then(/^the dry weight is not accepted$/) do
  expect_hd_dry_weight_to_be_refused
end

Then(/^Clyde sees these HD sessions$/) do |table|
  expect_hd_sessions_to_be(table.hashes)
end