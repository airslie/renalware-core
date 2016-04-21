Given(/^there exists the following global rule:$/) do |table|
  @rule = create_global_rule(table.rows_hash)
end

Given(/^there exists the following global rules:$/) do |table|
  table = table.transpose
  @rules = []
  table.rows.each do |row|
    params = Hash[table.headers.zip(row)]
    @rules << create_global_rule(params)
  end
end

Given(/^there exists the following global rule sets:$/) do |table|
  @rule_set = create_global_rule_set(table.rows_hash)
end

Given(/^Patty has an observation result value of (\d+)$/) do |result|
  if @rule.present?
    description_id = @rule.param_id
  else
    description_id =
      @rules
        .detect { |rule| rule.param_type = "ObservationResult" }
        .param_id
  end

  # TODO: Use the pathology world method
  observation_request = Renalware::Pathology::ObservationRequest.create!(
    requestor_order_number: "IX2671",
    requestor_name: "KCHDOC^DOCTOR, DR KCH",
    requested_at: Time.now,
    patient_id: @patty.id,
    description_id: 152
  )
  Renalware::Pathology::Observation.create!(
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
    description_id: 152
  )
  Renalware::Pathology::Observation.create(
    request_id: observation_request.id,
    description_id: @rule_set.observation_description_id,
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

Given(/^Patty has a patient rule:$/) do |table|
  @patient_rule = create_patient_rule(table.rows_hash)
end

Given(/^the current date is within the patient rule's start\/end date range yes$/) do
  @patient_rule.update_attributes!(
    start_date: Date.today - 1.days,
    end_date: Date.today + 1.days,
  )
end

Given(/^the current date is within the patient rule's start\/end date range no$/) do
  @patient_rule.update_attributes!(
    start_date: Date.today - 2.days,
    end_date: Date.today - 1.days,
  )end

When(/^the global pathology algorithm is ran for Patty in regime (.*)$/) do |regime|
  @global_algorithm = run_global_algorithm(@patty, regime)
end

When(/^the patient pathology algorithm is ran for Patty$/) do
  @patient_algorithm = run_patient_algorithm(@patty)
end

When(/^Clyde views the list of required pathology for Patty in regime (.*)$/) do |regime|
  @global_algorithm = run_global_algorithm(@patty, regime)
  @patient_algorithm = run_patient_algorithm(@patty)
end

Then(/^the required pathology should includes the test no$/) do
  expect(@global_algorithm.required_pathology).to eq([])
end

Then(/^the required pathology should includes the test yes$/) do
  expect(@global_algorithm.required_pathology).to eq([152])
end

Then(/^the required patient pathology should includes the test no$/) do
  expect(@patient_algorithm.required_pathology).to eq([])
end

Then(/^the required patient pathology should includes the test yes$/) do
  expect(@patient_algorithm.required_pathology).to eq([@patient_rule])
end

Then(/^Clyde sees these observations from the global algorithm$/) do |table|
  expect_observations_from_global(@global_algorithm, table)
end

Then(/^Clyde sees these observations from the patient algorithm$/) do |table|
  expect_observations_from_patient(@patient_algorithm, table)
end
