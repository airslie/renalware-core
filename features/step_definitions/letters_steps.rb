Given(/^Patty has a simple letter$/) do
  set_up_simple_letter_for(@patty, user: @nathalie)
end


When(/^Nathalie drafts a simple letter for Patty addressed to her doctor$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient_type: :doctor
  )
end

When(/^Nathalie drafts a simple letter for Patty addressed to herself$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient_type: :patient
  )
end

When(/^Nathalie drafts a simple letter for Patty addressed to John Doe in London$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: Time.zone.today,
    recipient_type: :other,
    recipient_info: { name: "John Doe", city: "London" }
  )
end

When(/^Nathalie submits an erroneous simple letter$/) do
  create_simple_letter(patient: @patty, user: @nathalie, issued_on: nil,
    recipient_type: :patient
  )
end


Then(/^Patty has a new simple letter$/) do
  expect_simple_letter_to_exist(@patty)
end

Then(/^Patty has a new simple letter for her doctor$/) do
  expect_simple_letter_to_exist(@patty, recipient_type: :doctor)
end

Then(/^Patty has a new simple letter for herself$/) do
  expect_simple_letter_to_exist(@patty, recipient_type: :patient)
end

Then(/^Patty has a new simple letter for John Doe in London$/) do
  expect_simple_letter_to_exist(@patty, recipient_type: :other, recipient: { name: "John Doe", city: "London"} )
end

Then(/^Nathalie can update Patty's simple letter$/) do
  update_simple_letter(patient: @patty, user: @nathalie)
end

Then(/^the simple letter is not accepted$/) do
  expect_simple_letter_to_be_refused
end
