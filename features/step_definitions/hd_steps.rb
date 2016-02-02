Given(/^Patty has HD preferences$/) do
  set_up_hd_preferences_for(@patty)
end

Given(/^Patty has an HD profile$/) do
  set_up_hd_profile_for(@patty, @clyde)
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