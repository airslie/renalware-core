Given(/^Patty has a patient rule:$/) do |table|
  @patient_rule = create_patient_rule(table.rows_hash)
end

Given(/^the current date is between the start\/end dates (yes|no)$/) do |within_rage|
  params =
    if within_rage == "yes"
      {
        start_date: Date.today - 1.days,
        end_date: Date.today + 1.days,
      }
    else
      {
        start_date: Date.today - 2.days,
        end_date: Date.today - 1.days,
      }
    end

  @patient_rule.update_attributes!(params)
end

When(/^the patient pathology algorithm is run for Patty$/) do
  @patient_algorithm = run_patient_algorithm(@patty)
end

Then(/^Clyde sees these observations from the patient algorithm$/) do |table|
  expect_observations_from_patient(@patient_algorithm, table)
end

Then(/^it is determined the patient's observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@patient_algorithm.required_pathology).to eq([@patient_rule])
  else
    expect(@patient_algorithm.required_pathology).to eq([])
  end
end
