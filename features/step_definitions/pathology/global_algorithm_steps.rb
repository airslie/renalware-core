Given(/^the rule set contains these rules:$/) do |table|
  @rules = create_global_rules_from_table(table)
end

Given(/^the global rule sets:$/) do |table|
  @rule_set = create_global_rule_set(table.rows_hash)
end

Given(/^Patty has observed an ([A-Z0-9]+) value of (\d+)$/) do |code, result|
  record_observations(
    patient: @patty,
    observations_attributes: [
      { "code" => code, "result" => result, "observed_at" => Date.current.to_s }
    ]
  )
end

Given(/^Patty was last tested for ([A-Z0-9]+)(\s|\s(\d+) days ago)$/) do |code, _time_ago, days|
  if days.present?
    observed_at = (Time.current - days.days).to_date
    record_observations(
      patient: @patty,
      observations_attributes: [
        { "code" => code, "result" => rand(100), "observed_at" => observed_at.to_s }
      ]
    )
  end
end

Given(/^Patty is currently prescribed Ephedrine Tablet (yes|no)$/) do |perscribed|
  if perscribed == "yes"
    drug = Renalware::Drugs::Drug.find_by(name: "Ephedrine Tablet")
    route = Renalware::MedicationRoute.find_by(name: "Per Oral")
    @patty.medications.create!(
      drug: drug,
      medication_route: route,
      dose: "20mg",
      frequency: "daily",
      start_date: Time.current - 1.week,
      provider: 0,
      treatable: @patty
    )
  end
end

When(/^the global pathology algorithm is run for Patty in regime (.*)$/) do |regime|
  @required_global_observations = run_global_algorithm(@patty, regime)
end

Then(/^it is determined the observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_global_observations).to eq(
      [@rule_set.observation_description]
    )
  else
    expect(@required_global_observations).to eq([])
  end
end
