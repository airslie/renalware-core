Given(/^Patty has a recorded prescription|Patty has current prescriptions$/) do
  seed_prescription_for(
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    terminated_on: nil
  )
end

Given(/^Patty has the following prescriptions:$/) do |table|
  table.hashes.each do |row|
    seed_prescription_for(
      patient: @patty,
      drug_name: row[:drug_name],
      dose: row[:dose],
      route_code: row[:route_code],
      frequency: row[:frequency],
      prescribed_on: Time.now - 1.month,
      provider: row[:provider],
      terminated_on: row[:terminated_on]
    )
  end
end

When(/^Clyde records the prescription for Patty$/) do
  record_prescription_for_patient(
    user: @clyde,
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    terminated_on: nil
  )
end

When(/^Clyde views the list of prescriptions for Patty$/) do
  @current_prescriptions, @historical_prescriptions = view_prescriptions_for(@clyde, @patty)
end

Then(/^the prescription is recorded for Patty$/) do
  expect_prescription_to_be_recorded(patient: @patty)
end

Then(/^Clyde can revise the prescription$/) do
  revise_prescription_for(
    patient: @patty,
    user: @clyde,
    drug_name: "Cefuroxime Injection"
  )

  expect_prescription_to_be_revised(patient: @patty)
end

Then(/^Clyde can terminate the prescription for the patient$/) do
  terminate_prescription_for(
    patient: @patty,
    user: @clyde
  )
end

Then(/^Clyde should see these current prescriptions$/) do |table|
  expect_current_prescriptions_to_match(@current_prescriptions, table.hashes)
end

Then(/^Clyde should see these historical prescriptions$/) do |table|
  expect_current_prescriptions_to_match(@historical_prescriptions, table.hashes)
end
