Given(/^I have a user in the database$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^I am on the signin page$/) do
  pending # express the regexp above with the code you wish you had
end

Given(/^that I'm logged in$/) do
  @user ||= FactoryGirl.create(:user, :approved, :super_admin)
  login_as @user
end

When(/^I sign in$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see my dashboard$/) do
  pending # express the regexp above with the code you wish you had
end
