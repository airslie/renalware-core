Given(/^there exist the following global rules:$/) do |table|
  @rule = Renalware::Pathology::RequestAlgorithm::GlobalRule.create!(table.rows_hash)
end

Given(/^Patty has an observation result value of (\d+)$/) do |result|
  # TODO: Use the pathology world method
  observation_request = Renalware::Pathology::ObservationRequest.create(
    requestor_order_number: "IX2671",
    requestor_name: "KCHDOC^DOCTOR, DR KCH",
    requested_at: Time.now,
    patient_id: @patty.id,
    description_id: 1
  )
  Renalware::Pathology::Observation.create(
    request_id: observation_request.id,
    description_id: @rule.param_id,
    observed_at: Time.now,
    result: result
  )
end

Given(/^Patty was last tested for vitamin B12 Serum $/) do
  # Do Nothing
end

Given(/^Patty was last tested for vitamin B12 Serum (\d+) days ago$/) do |days|
  # TODO: Use the pathology world method
  observation_request = Renalware::Pathology::ObservationRequest.create(
    requestor_order_number: "IX2671",
    requestor_name: "KCHDOC^DOCTOR, DR KCH",
    requested_at: Time.now,
    patient_id: @patty.id,
    description_id: 2
  )
  Renalware::Pathology::Observation.create(
    request_id: observation_request.id,
    description_id: 152,
    observed_at: Time.now - days.days,
    result: 0
  )
end

When(/^the global pathology algorithm is ran for Patty in regime (.*)$/) do |regime|
  @request_algorithm = Renalware::Pathology::RequestAlgorithm::Global.new(@patty, regime)
end

Then(/^the required pathology should includes the test no$/) do
  expect(@request_algorithm.required_pathology).to eq([])
end

Then(/^the required pathology should includes the test yes$/) do
  expect(@request_algorithm.required_pathology).to eq([152])
end
