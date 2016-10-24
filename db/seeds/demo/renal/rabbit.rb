module Renalware
  log "Adding Renal Profile for Roger RABBIT"

  Renal::Profile.create!(
    patient_id: 1,
    esrf_on: "2015-05-05",
    prd_description_id: 109,
    document: {}
  )
end
