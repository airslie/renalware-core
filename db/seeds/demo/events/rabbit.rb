module Renalware
  log "Adding Events for Roger RABBIT"

  rabbit = Patient.find_by(family_name: "RABBIT", given_name: "Roger")

  Events::Event.find_or_create_by!(
    patient_id: rabbit.to_param,
    event_type_id: 19,
    description: "meeting with family in clinic",
    notes: "anxious about medication changes",
    date_time: Time.now - 2.weeks
  )

  Events::Event.find_or_create_by!(
    patient_id: rabbit.to_param,
    event_type_id: 25,
    description: "call regarding meds",
    notes: "told patient to get other drug info from GP",
    date_time: Time.now - 12.days
  )

  Events::Event.find_or_create_by!(
    patient_id: rabbit.to_param,
    event_type_id: 8,
    description: "email re next clinic visit",
    notes: "reminded patient to bring complete drug list to clinic",
    date_time: Time.now - 5.days
  )
end
