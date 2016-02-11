Given(/^Patty has an access$/) do
  set_up_access_for(@patty, user: Renalware::User.first)
end


When(/^Clyde records an access for Patty$/) do
  create_access(patient: @patty, user: @clyde, site: Renalware::Accesses::Site.first)
end

When(/^Clyde submits an erroneous access$/) do
  create_access(patient: @patty, user: @clyde, site: nil)
end


Then(/^Patty has a new access$/) do
  expect_access_to_exist(@patty)
end

Then(/^Clyde can update Patty's access$/) do
  update_access(patient: @patty, user: @clyde)
end

Then(/^the access is not accepted$/) do
  expect_access_to_be_refused
end
