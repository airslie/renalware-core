Given(/^the global rule:$/) do |table|
  @rule = create_global_rule(table.rows_hash)
end

Given(/^the global rules:$/) do |table|
  table = table.transpose
  @rules = []
  table.rows.each do |row|
    params = Hash[table.headers.zip(row)]
    @rules << create_global_rule(params)
  end
end

Given(/^the global rule sets:$/) do |table|
  @rule_set = create_global_rule_set(table.rows_hash)
end

Given(/^Patty has observed an ([A-Z0-9]+) value of (\d+)$/) do |code, result|
  record_observations(
    patient: @patty,
    observations_attributes: [
      { 'code' => code, 'result' => result, 'observed_at' => Date.today.to_s }
    ]
  )
end

Given(/^Patty was last tested for ([A-Z0-9]+) $/) do |code|
  # Do Nothing
end

Given(/^Patty was last tested for ([A-Z0-9]+) (\d+) days ago$/) do |code, days|
  observed_at = (Time.now - days.days).to_date
  record_observations(
    patient: @patty,
    observations_attributes: [
      { 'code' => code, 'result' => rand(100), 'observed_at' => observed_at.to_s }
    ]
  )
end

Given(/^Patty is currently on the drug Ephedrine Tablet (yes|no)$/) do |perscribed|
  if perscribed == "yes"
    drug = Renalware::Drugs::Drug.find_by(name: "Ephedrine Tablet")
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

When(/^the global pathology algorithm is run for Patty in regime (.*)$/) do |regime|
  @global_algorithm = run_global_algorithm(@patty, regime)
end

When(/^Clyde views the list of required pathology for Patty in regime (.*)$/) do |regime|
  @global_algorithm = run_global_algorithm(@patty, regime)
  @patient_algorithm = run_patient_algorithm(@patty)
end

Then(/^Clyde sees these observations from the global algorithm$/) do |table|
  expect_observations_from_global(@global_algorithm, table)
end

Then(/^it is determined the observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@global_algorithm.required_pathology).to eq(
      [@rule_set.observation_description_id]
    )
  else
    expect(@global_algorithm.required_pathology).to eq([])
  end
end
