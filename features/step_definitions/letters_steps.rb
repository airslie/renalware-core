Given(/^Patty has a simple letter$/) do
  set_up_simple_letter_for(@patty, user: @nathalie)
end


When(/^Nathalie drafts a simple letter for Patty$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today)
end

When(/^Nathalie submits an erroneous simple letter$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: nil)
end


Then(/^Patty has a new simple letter$/) do
  expect_simple_letter_to_exist(@patty)
end

Then(/^Nathalie can update Patty's simple letter$/) do
  update_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^the simple letter is not accepted$/) do
  expect_simple_letter_to_be_refused
end
