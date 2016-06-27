Given(/^Patty has a recorded medication|Patty has current medications$/) do
  seed_medication_for(
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end

Given(/^Patty has medications:$/) do |table|
  table.hashes.each do |row|
    seed_medication_for(
      patient: @patty,
      drug_name: row[:drug_name],
      dose: row[:dose],
      route_code: row[:route_code],
      frequency: row[:frequency],
      starts_on: Time.now-1.month,
      provider: row[:provider],
    )
  end
end

When(/^Clyde records the medication for Patty$/) do
  record_medication_for_patient(
    user: @clyde,
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end

When(/^Clyde views the list of medications for Patty$/) do
  pending # express the regexp above with the code you wish you had
end


Then(/^the medication is recorded for Patty$/) do
  expect_medication_to_be_recorded(patient: @patty)
end

Then(/^Clyde can revise the medication$/) do
  revise_medication_for(
    patient: @patty,
    user: @clyde,
    drug_name: "Cefuroxime Injection"
  )

  expect_medication_to_be_revised(patient: @patty)
end

Then(/^Clyde can terminate the medication for the patient$/) do
  terminate_medication_for(
    patient: @patty,
    user: @clyde
  )
end
