Given(/^there exist the following request algorithm rules:$/) do |table|
  @rule = Renalware::Pathology::RequestAlgorithm::Rule.create(table.rows_hash)
end

When(/^the algorithm is ran for Patty in Nephrology$/) do
  @request_algorithm = Renalware::Pathology::RequestAlgorithm.new(@patty, 'Nephrology')
end

Then(/^The test should be required Patty$/) do
  expect(@request_algorithm.required_pathology).to eq([@rule.request])
end

Then(/^The test should not be required Patty$/) do
  expect(@request_algorithm.required_pathology).to eq([])
end
