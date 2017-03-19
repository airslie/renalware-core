Given(/^Patty has a recorded prescription|Patty has current prescriptions$/) do
  seed_prescription_for(
    patient: @patty
  )
end

Given(/^Patty has the following prescriptions:$/) do |table|
  table.hashes.each_with_index do |row, index|
    dose_amount, dose_unit = row[:dose].split(" ")
    prescribed_on_default = Time.current.beginning_of_day - 1.month + index.days

    seed_prescription_for(
      patient: @patty,
      drug_name: row[:drug_name],
      dose_amount: dose_amount,
      dose_unit: dose_unit,
      route_code: row[:route_code],
      frequency: row[:frequency],
      prescribed_on: row.fetch("prescribed_on", prescribed_on_default),
      last_delivery_date: "10-10-2015",
      provider: row[:provider],
      terminated_on: row[:terminated_on]
    )
  end
end

Given(/^Patty has a prescription:$/) do |table|
  row = table.hashes.first
  dose_amount, dose_unit = row[:dose].split(" ")

  @prescription = seed_prescription_for(
    patient: @patty,
    drug_name: row[:drug_name],
    dose_amount: dose_amount,
    dose_unit: dose_unit,
    route_code: row[:route_code],
    frequency: row[:frequency],
    prescribed_on: Time.current - 1.month,
    provider: row[:provider],
    administer_on_hd: row[:administer_on_hd],
    last_delivery_date: "10-10-2015",
    terminated_on: row[:terminated_on]
  )
end

Given(/^Patty is being prescribed (.+)$/) do |drug_name|
  seed_prescription_for(
    patient: @patty,
    drug_name: drug_name
  )
end

When(/^Clyde records the prescription for Patty$/) do
  record_prescription_for_patient(
    user: @clyde,
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    last_delivery_date: "10-10-2015",
    terminated_on: nil
  )
end

When(/^Clyde records the prescription for Patty with a termination date$/) do

  record_prescription_for_patient(
    user: @clyde,
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-Oct-2015",
    provider: "GP",
    last_delivery_date: "10-10-2015",
    terminated_on: "20-Oct-2015"
  )
end

When(/^Clyde flags the prescription for Patty to be administered during an HD session$/) do
  record_prescription_for_patient(
    user: @clyde,
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-Oct-2015",
    last_delivery_date: "10-10-2015",
    administer_on_hd: true,
    provider: "GP",
    terminated_on: "20-10-2015"
  )
end

When(/^Clyde views the list of prescriptions for Patty$/) do
  @current_prescriptions, @historical_prescriptions = view_prescriptions_for(@clyde, @patty)
end

When(/^Clyde revises the prescription for Patty with these changes:$/) do |table|
  revise_prescription_for(
    prescription: @prescription,
    patient: @patty,
    user: @clyde,
    prescription_params: table.rows_hash
  )
end

When(/^Clyde makes an invalid revision to Patty's prescription$/) do
  revise_prescription_for(
    prescription: @prescription,
    patient: @patty,
    user: @clyde,
    prescription_params: { dose_amount: nil }
  )
end

Then(/^the prescription is recorded for Patty$/) do
  expect_prescription_to_be_recorded(patient: @patty)
end

Then(/^Clyde is prompted to administer the prescription during Patty's future HD sessions$/) do
  expect_prescription_to_be_recorded(patient: @patty, administer_on_hd: true)
end

When(/^Clyde terminates the prescription for the patient$/) do
  terminate_prescription_for(
    patient: @patty,
    user: @clyde
  )
end

When(/^Clyde records an invalid termination for a prescription$/) do
  terminate_prescription_for(
    patient: @patty,
    user: @clyde,
    terminated_on: nil
  )
end

Then(/^Clyde is recorded as the user who terminated the prescription$/) do
  expect_prescription_to_be_terminated_by(@clyde, patient: @patty)
end

Then(/^Clyde should see these current prescriptions$/) do |table|
  expect_current_prescriptions_to_match(@current_prescriptions, table.hashes)
end

Then(/^Clyde should see these historical prescriptions$/) do |table|
  expect_current_prescriptions_to_match(@historical_prescriptions, table.hashes)
end

Then(/^Patty should have the following prescriptions:$/) do |table|
  expect_patient_to_have_prescriptions(@patty, table.hashes)
end

Then(/^the prescription termination is rejected$/) do
  expect_termination_to_be_rejected(@patty)
end

Then(/^the prescription revision is rejected$/) do
  expect_prescription_revision_to_be_rejected(@patty, { dose_amount: nil })
end
