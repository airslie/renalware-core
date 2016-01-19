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
