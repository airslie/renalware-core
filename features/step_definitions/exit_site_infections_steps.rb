When("Clyde records an exit site infection for Patty") do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016",
    clinical_presentation: %w(pain swelling),
    outcome: "Recovered well. Scheduled another training review session.",
    recurrent: false,
    catheter_removed: false,
    cleared: false
  )
end

Given("Clyde recorded an exit site infection for Patty") do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    clinical_presentation: %w(pain swelling),
    diagnosed_on: "10-10-2016",
    outcome: "Recovered well. Scheduled another training review session.",
    recurrent: false,
    catheter_removed: false,
    cleared: false
  )
end

When("records the organism for the infection") do
  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

Given("recorded the organism for the infection") do
  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Staphylococcus aureus"
  )
end

Given("recorded the prescription for the infection") do
  record_prescription_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector
  )
end

When("records the prescription for the infection") do
  record_prescription_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector
  )
end

Then("an exit site infection is recorded for Patty") do
  expect_exit_site_infection_to_recorded(patient: @patty)
end

Given("Patty is being treated for an exit site infection") do
  record_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    clinical_presentation: %w(pain swelling),
    diagnosed_on: Date.current - 1.day,
    outcome: "Recovered well. Scheduled another training review session."
  )

  record_organism_for(
    infectable: infection_for(@patty),
    organism_name: "Staphylococcus aureus"
  )

  seed_prescription_for(
    patient: @patty,
    treatable: infection_for(@patty),
    drug_name: "Ciprofloxacin Infusion",
    dose_amount: "100",
    dose_unit: "millilitre",
    route_code: "PO",
    frequency: "once a day",
    prescribed_on: "10-10-2015",
    administer_on_hd: false,
    provider: "GP",
    drug_selector: exit_site_infection_drug_selector,
    terminated_on: nil
  )
end

Then("Clyde can revise the exit site infection") do
  revise_exit_site_infection_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: Date.current - 10.days
  )

  revise_organism_for(
    infectable: infection_for(@patty),
    sensitivity: "Lorem ipsum.",
    resistance: "tetracycline"
  )

  revise_prescription_for(
    prescription: @patty.prescriptions.first,
    patient: @patty,
    user: @clyde,
    drug_selector: exit_site_infection_drug_selector,
    prescription_params: { drug_name: "Cefotaxime Injection" }
  )

  expect_exit_site_infections_revisions_recorded(patient: @patty)
end

Then("Clyde can terminate the organism for the infection") do
  terminate_organism_for(
    infectable: infection_for(@patty),
    user: @clyde
  )
end

Then("Clyde can terminate the prescription for the infection") do
  terminate_prescription_for(
    patient: @patty,
    user: @clyde
  )
end
