module Renalware

  rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")

  log "Adding Body Composition Measurement for Roger RABBIT" do
    Clinical::BodyComposition.create!(
      patient_id: rabbit.to_param,
      assessed_on: 2.days.ago.to_date,
      created_by_id: Renalware::User.first.id,
      updated_by_id: Renalware::User.last.id,
      assessor_id: Renalware::User.first.id,
      overhydration: 34.1,
      volume_of_distribution: 52.1,
      total_body_water: 23.1,
      extracellular_water: 63.1,
      intracellular_water: 23.1,
      lean_tissue_index: 78.1,
      fat_tissue_index: 32.1,
      lean_tissue_mass: 32.1,
      fat_tissue_mass: 42.1,
      adipose_tissue_mass: 15.1,
      body_cell_mass: 53.1,
      quality_of_reading: 65.123,
      notes: "Lorem rabbitum body composition notes"
    )
  end
end
