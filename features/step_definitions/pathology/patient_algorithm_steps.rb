def get_patient(patient_name)
  instance_variable_get("@#{patient_name.downcase}".to_sym)
end

Given(/^(\w+) has a patient rule:$/) do |patient_name, table|
  patient = get_patient(patient_name)
  @patient_rule = create_patient_rule(
    table.rows_hash.merge("patient" => patient)
  )
end

Given(/^the current date is between the rule's start\/end dates (yes|no)$/) do |within_rage|
  update_patient_rule_start_end_dates(@patient_rule, within_rage)
end

When(/^the patient pathology algorithm is run for Patty$/) do
  @required_patient_observations = run_patient_algorithm(@patty, @clyde)
end

Then(/^it is determined the patient's observation is (required|not required)$/) do |determined|
  if determined == "required"
    expect(@required_patient_observations).to eq([@patient_rule])
  else
    expect(@required_patient_observations).to eq([])
  end
end
