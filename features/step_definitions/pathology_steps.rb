Then(/^an observation request is created with the following attributes:$/) do |table|
  expect_observation_request_to_be_created(table.rows_hash)
end
