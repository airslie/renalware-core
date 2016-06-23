Given(/^Clyde recorded a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end

Given(/^Patty has problems and notes$/) do
  seed_problem_for(@patty, Renalware::User.first)
end


When(/^Clyde records a problem for Patty$/) do
  record_problem_for(patient: @patty, user: @clyde)
end

When(/^records a note for the problem$/) do
  problem = problem_for(@patty)
  record_problem_note_for(problem: problem, user: @clyde)
end


Then(/^a problem is recorded for Patty$/) do
  expect_problem_to_be_recorded(patient: @patty)
  problem = problem_for(@patty)
  expect_problem_note_to_be_recorded(problem: problem)
end

Then(/^Clyde can revise the problem$/) do
  revise_problem_for(
    patient: @patty,
    user: @clyde,
    description: "something else"
  )

  expect_problem_revisions_to_be_recorded(patient: @patty)
end

Then(/^Clyde can add a note to the problem$/) do
  problem = problem_for(@patty)
  record_problem_note_for(problem: problem, user: @clyde)
  expect_problem_note_to_be_recorded(problem: problem)
end