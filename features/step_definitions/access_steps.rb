Given(/^Patty has an access profile$/) do
  set_up_access_profile_for(@patty, user: Renalware::User.first)
end


When(/^Clyde records an access profile for Patty$/) do
  create_access_profile(patient: @patty, user: @clyde, site: Renalware::Accesses::Site.first)
end

When(/^Clyde submits an erroneous access profile$/) do
  create_access_profile(patient: @patty, user: @clyde, site: nil)
end


Then(/^Patty has a new access profile$/) do
  expect_access_profile_to_exist(@patty)
end

Then(/^Clyde can update Patty's access profile$/) do
  update_access_profile(patient: @patty, user: @clyde)
end

Then(/^the access profile is not accepted$/) do
  expect_access_profile_to_be_refused
end
