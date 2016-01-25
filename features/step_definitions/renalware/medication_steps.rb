Given(/^Patty has a medication recorded$/) do
  record_medication_for(
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end

When(/^Clyde records the medication for Patty$/) do
  record_medication_for(
    patient: @patty,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end

Then(/^the medication is recorded for Patty$/) do
  expect_medication_to_be_recorded(patient: @patty)
end

Then(/^Clyde can revise the medication$/) do
  revise_medication_for(
    patient: @patty,
    drug_name: "Cefotaxime Injection"
  )

  expect_medication_to_be_revised(patient: @patty)
end

Then(/^Clyde can terminate the medication for the patient$/) do
  terminate_medication_for(
    patient: @patty,
    user: @clyde
  )
end
