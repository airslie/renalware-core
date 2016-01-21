Given(/^Patty is being treated for a peritonitis episode$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )

  record_organism_for(
    infectable: episode_for(@patty),
    organism_name: "Acineobactor"
  )

  record_medication_for(
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP",
    drug_selector: peritonitis_episode_drug_selector
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
    organism_name: "Acineobactor"
  )
end

Given(/^recorded the medication for the episode$/) do
  record_medication_for(
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
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
    organism_name: "Acineobactor"
  )
end

When(/^records the medication for the episode$/) do
  record_medication_for(
    treatable: episode_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
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
    diagnosed_on: Date.current - 10.day
  )

  revise_organism_for(
    infectable: episode_for(@patty),
    sensitivity: "Lorem ipsum."
  )

  revise_medication_for(
    treatable: episode_for(@patty),
    drug_name: "Cefotaxime Injection"
  )

  expect_peritonitis_episodes_revisions_recorded(patient: @patty)
end

Then(/^Clyde can terminate the organism for the episode$/) do
  terminate_organism_for(
    infectable: episode_for(@patty),
    user: @clyde
  )
end

Then(/^Clyde can terminate the medication for the episode$/) do
  terminate_medication_for(
    treatable: episode_for(@patty),
    user: @clyde
  )
end
