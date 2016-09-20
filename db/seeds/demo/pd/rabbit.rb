module Renalware

  log "Adding Exit Site Infection for Roger RABBIT"

  PD::ExitSiteInfection.create({
    patient_id: 1,
    diagnosis_date: "2015-06-09",
    treatment: "liquid and electrolyte replacement ",
    outcome: "Recovered well. Scheduled another training review session.", notes: ""
  })

  log "Adding Peritonitis Episode for Roger RABBIT"

  PD::PeritonitisEpisode.create({
    patient_id: 1,
    diagnosis_date: "2015-09-14",
    treatment_start_date: "2015-09-14",
    treatment_end_date: "2015-09-21",
    episode_type_id: 6,
    catheter_removed: true,
    line_break: false,
    exit_site_infection: false,
    diarrhoea: false,
    abdominal_pain: true,
    fluid_description_id: 4,
    white_cell_total: 5,
    white_cell_neutro: 57,
    white_cell_lympho: 37,
    white_cell_degen: 3,
    white_cell_other: 3,
    notes: ""
  })

  PD::InfectionOrganism.create({
    organism_code_id: 33,
    sensitivity: "+++",
    infectable_id: 1,
    infectable_type: "Renalware::PD::PeritonitisEpisode"
  })

  PD::InfectionOrganism.create({
    organism_code_id: 4,
    sensitivity: "unknown",
    infectable_id: 1,
    infectable_type: "Renalware::PD::ExitSiteInfection"
  })
end
