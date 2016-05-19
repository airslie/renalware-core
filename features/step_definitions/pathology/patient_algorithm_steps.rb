Given(/^Patty has a patient rule:$/) do |table|
  @patient_rule = create_patient_rule(
    table.rows_hash.merge("patient" => @patty)
  )
end

Given(/^the current date is between the rule's start\/end dates (yes|no)$/) do |within_rage|
  update_patient_rule_start_end_dates(@patient_rule, within_rage)
end

When(/^Clyde records a new patient rule for Patty$/) do
  record_patient_rule(
    @clyde,
    patient: @patty,
    lab: "Biochem",
    test_description: "Test for HepBsAb",
    sample_number_bottles: 1,
    frequency: "Always"
  )
end

When(/^the patient pathology algorithm is run for Patty$/) do
  patty_pathology = Renalware::Pathology.cast_patient(@patty)
  @required_patient_observations = run_patient_algorithm(patty_pathology)
end

Then(/^it is determined the patient's observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_patient_observations).to eq([@patient_rule])
  else
    expect(@required_patient_observations).to eq([])
  end
end

Then(/^Patty has a new patient rule$/) do
  expect_patient_rules_on_patient(@patty)
end
