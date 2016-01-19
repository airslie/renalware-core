When(/^Clyde records a peritonitis episode for Patty$/) do
  record_peritonitis_episode_for(
    patient: @patty,
    user: @clyde,
    diagnosed_on: "10-10-2016"
  )
end

When(/^records the organism for the episode$/) do
  record_organism_for(
    infectable: @patty.peritonitis_episodes.last!,
    organism_name: "Acineobactor"
  )
end

When(/^records the medication for the episode$/) do
  record_medication_for(
    treatable: @patty.peritonitis_episodes.last!,
    drug_name: "Ciprofloxacin Infusion",
    dose: "100 ml",
    route_name: "PO",
    frequency: "once a day",
    starts_on: "10-10-2015",
    provider: "GP"
  )
end
