When(/^Clyde records an exit site infection for Patty$/) do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016",
    outcome: "Recovered well. Scheduled another training review session."
  )
end

Given(/^Clyde recorded an exit site infection for Patty$/) do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016",
    outcome: "Recovered well. Scheduled another training review session."
  )
end

When(/^records the organism for the infection$/) do
  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Acineobactor"
  )
end

Given(/^recorded the organism for the infection$/) do
  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Acineobactor"
  )
end

Given(/^recorded the medication for the infection$/) do
  record_medication_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector
  )
end

When(/^records the medication for the infection$/) do
  record_medication_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector
  )
end

Then(/^an exit site infection is recorded for Patty$/) do
  expect_exit_site_infection_to_recorded(patient: @patty)
end

Given(/^Patty is being treated for an exit site infection$/) do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: Date.current - 1.day,
    outcome: "Recovered well. Scheduled another training review session."
  )

  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Acineobactor"
  )

  seed_medication_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_code: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector,
    deleted_at: nil
  )
end

Then(/^Clyde can revise the exist site infection$/) do
  revise_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: Date.current - 10.day
  )

  revise_organism_for(
    infectable: infection_for(@patty),
    sensitivity: "Lorem ipsum."
  )

  revise_medication_for(
    patient: @patty,
    user: @user,
    drug_name: "Cefotaxime Injection",
    drug_selector: exit_site_infection_drug_selector
  )

  expect_exit_site_infections_revisions_recorded(patient: @patty)
end

Then(/^Clyde can terminate the organism for the infection$/) do
  terminate_organism_for(
    infectable: infection_for(@patty),
    user: @clyde
  )
end

Then(/^Clyde can terminate the medication for the infection$/) do
  terminate_medication_for(
    patient: @patty,
    user: @clyde
  )
end
