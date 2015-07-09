log '--------------------Adding Problems for Roger RABBIT--------------------'

rabbit = Patient.find_by(surname: 'RABBIT', forename: 'Roger')

randweeks = (0..52).to_a
file_path = File.join(demo_path, 'rabbit_problems.csv')
logcount=0

CSV.foreach(file_path, headers: true) do |row|
  randwk = randweeks.sample
  date = Time.now - randwk.weeks
  description = row['description']
  snomed_id = row['snomed_id ']
  log "   ... adding #{snomed_id}: #{description} from #{date}"
  logcount += 1
  Problem.find_or_create_by!(
    patient_id: rabbit.to_param,
    description: description,
    date: date,
    snomed_id: snomed_id)
end

log "#{logcount} Problems seeded"

log '--------------------Adding Modalities for Roger RABBIT---------------------'

file_path = File.join(demo_path, 'rabbit_modalities.csv')
logcount=0
CSV.foreach(file_path, headers: true) do |row|
  logcount += 1
  Modality.create(
    patient_id: rabbit.to_param,
    modality_code_id: row['modality_code_id'],
    modality_reason_id: row['modality_reason_id'],
    modal_change_type: row['modal_change_type'],
    start_date: row['start_date'],
    termination_date: row['termination_date'],
    deleted_at: row['deleted_at'],
    created_at: row['created_at'],
    updated_at: row['updated_at']
  )
end

log "#{logcount} Modalities seeded"

log '--------------------Adding Events for Roger RABBIT--------------------'

Event.find_or_create_by!(
  patient_id: rabbit.to_param,
  event_type_id: 19,
  description: "meeting with family in clinic",
  notes: "anxious about medication changes",
  date_time: Time.now - 2.weeks
)


Event.find_or_create_by!(
  patient_id: rabbit.to_param,
  event_type_id: 25,
  description: "call regarding meds",
  notes: "told patient to get other drug info from GP",
  date_time: Time.now - 12.days
)

Event.find_or_create_by!(
  patient_id: rabbit.to_param,
  event_type_id: 8,
  description: "email re next clinic visit",
  notes: "reminded patient to bring complete drug list to clinic",
  date_time: Time.now - 5.days
)

log "3 Events seeded"
