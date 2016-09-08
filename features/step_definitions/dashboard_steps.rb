Then(/^Patty's draft letter is accessible from Nathalie's dashboard$/) do
  expect_draft_letter_accessible_from_dashboard(user: @nathalie, patient: @patty)
end
