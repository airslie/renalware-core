Then(/^an observation request is created with the following attributes:$/) do |table|
  expect_observation_request_to_be_created(table.rows_hash)
end

Then(/^an observations are created with the following attributes:$/) do |table|
  expect_observations_to_be_created(table.hashes)
end

Given(/^the following observations were recorded$/) do |table|
  record_observations(patient: @patty, observations_attributes: table.hashes)
end

Then(/^the doctor views the following recents observation results:$/) do |table|
  expect_pathology_recent_observations(user: @nathalie, patient: @patty, rows: table.raw)
  expect_pathology_result_report(user: @nathalie, patient: @patty, rows: table.raw)
end
