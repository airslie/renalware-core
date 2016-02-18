Given(/^Clyde recorded a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end


When(/^Clyde records a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end

When(/^records a note for the problem$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^a problem is recorded for Patty$/) do
  expect_problem_to_recorded(patient: @patty)
end

Then(/^Clyde can revise the problem$/) do
  revise_problem_for(
    patient: @patty,
    user: @clyde,
    description: "something else"
  )

  expect_problem_revisions_recorded(patient: @patty)
end

Then(/^Clyde can add a note to the problem$/) do
  pending # express the regexp above with the code you wish you had
end