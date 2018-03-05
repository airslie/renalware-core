# frozen_string_literal: true

Given(/^Patty is being treated for a peritonitis episode$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )

  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )

  seed_prescription_for(
    patient: @patty,
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    drug_selector: peritonitis_episode_drug_selector,
    terminated_on: nil
  )
end

Given(/^Clyde recorded a peritonitis episode for Patty$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )
end

Given(/^recorded the organism for the episode$/) do
  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

Given(/^recorded the prescription for the episode$/) do
  record_prescription_for(
    patient: @patty,
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    drug_selector: peritonitis_episode_drug_selector
  )
end

When(/^Clyde records a peritonitis episode for Patty$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )
end

When(/^records the organism for the episode$/) do
  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

When(/^records the prescription for the episode$/) do
  record_prescription_for(
    patient: @patty,
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    drug_selector: peritonitis_episode_drug_selector
  )
end

Then(/^a peritonitis episode is recorded for Patty$/) do
  expect_peritonitis_episode_to_be_recorded(patient: @patty)
end

Then(/^Clyde can revise the peritonitis episode$/) do
  revise_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "11-11-2015"
  )

  revise_organism_for(
    infectable: episode_for(@patty),
    sensitivity: "Lorem ipsum.",
    resistance: "tetracycline"
  )

  revise_prescription_for(
    prescription: @patty.prescriptions.first,
    patient: @patty,
    user: @clyde,
    drug_selector: peritonitis_episode_drug_selector,
    prescription_params: { drug_name: "Cefotaxime Injection" }
  )

  expect_peritonitis_episodes_revisions_recorded(patient: @patty)
end

Then(/^Clyde can terminate the organism for the episode$/) do
  terminate_organism_for(
    infectable: episode_for(@patty),
    user: @clyde
  )
end

Then(/^Clyde can terminate the prescription for the episode$/) do
  terminate_prescription_for(
    patient: @patty,
    user: @clyde
  )
end
