Given(/^there exists the following global rule:$/) do |table|
  @rule = Renalware::Pathology::RequestAlgorithm::GlobalRule.create!(table.rows_hash)
end

Given(/^there exists the following global rules:$/) do |table|
  table = table.transpose
  @rules = []
  table.rows.each do |row|
    params = Hash[table.headers.zip(row)]
    @rules << Renalware::Pathology::RequestAlgorithm::GlobalRule.create!(params)
  end
end

Given(/^there exists the following global rule sets:$/) do |table|
  @rule_set = Renalware::Pathology::RequestAlgorithm::GlobalRuleSet.create!(table.rows_hash)
end

Given(/^Patty has an observation result value of (\d+)$/) do |result|
  if @rule.present?
    description_id = @rule.param_id
  else
    description_id =
      @rules
        .find { |rule| rule.param_type = 'ObservationResult' }
        .param_id
  end

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
    description_id: description_id,
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

Given(/^Patty is currently on drug with id=(\d+) (yes|no)$/) do |drug_id, perscribed|
  if perscribed == "yes"
    drug = Renalware::Drugs::Drug.find(drug_id)
    route = Renalware::MedicationRoute.find_by(name: "Per Oral")
    @patty.medications.create!(
      drug: drug,
      medication_route: route,
      dose: "20mg",
      frequency: "daily",
      start_date: Time.now - 1.week,
      provider: 0,
      treatable: @patty
    )
  end
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
