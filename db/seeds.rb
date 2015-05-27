require 'csv'

def log(msg)
  puts msg
end

def maybe_value(value)
  return if value == 'NULL' || value.blank?
  value
end

def add_super_admin
  log 'Adding default user...'
  Rake::Task['users:add_user'].invoke
end


log 'Creating Roles...'
super_admin_role = Role.find_or_create_by!(name: :super_admin)
Role.find_or_create_by!(name: :admin)
Role.find_or_create_by!(name: :clinician)

add_super_admin if Rails.env.development?

log 'Adding Drug types...'

DrugType.find_or_create_by!(name: "Antibiotic")
DrugType.find_or_create_by!(name: "ESA")
DrugType.find_or_create_by!(name: "Immunosuppressant")
DrugType.find_or_create_by!(name: "Peritonitis")
DrugType.find_or_create_by!(name: "Controlled")

log '-----------Adding Drugs----------'

file_path = Rails.root.join('db', 'csv', 'drugs_merged.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  name = row['drugname']
  logcount += 1
  Drug.find_or_create_by!(name: name)
end

log "...#{logcount} drugs seeded!"

log '-----------Assigning Drug Types----------'

file_path = Rails.root.join('db', 'csv', 'drug_drug_types.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  drug_id = row['drug_id']
  drug_type_id = row['drug_type_id']
  logcount += 1
  DrugDrugType.find_or_create_by!(drug_id: drug_id, drug_type_id: drug_type_id)
end

log "...#{logcount} drugs types assigned!"

log '-----------Adding Event Types----------'

file_path = Rails.root.join('db', 'csv', 'rw_eventtypes.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  eventtype = row['eventtype']
  log "   ... adding #{eventtype}"
  logcount += 1
  PatientEventType.find_or_create_by!(name: eventtype)
end

log "...#{logcount} eventtypes seeded!"

log '-----------Adding Ethnicities----------'

file_path = Rails.root.join('db', 'csv', 'rw_ethnicities.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  name = row['name']
  log "   ... adding #{name}"
  logcount += 1
  Ethnicity.find_or_create_by!(name: name)
end

log "...#{logcount} ethnicities seeded!"

log '-----------Adding Modality Codes----------'

file_path = Rails.root.join('db', 'csv', 'rw_modalcodes.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  code = row['code']
  name = row['name']
  log "   ... adding #{code}: #{name}"
  logcount += 1
  ModalityCode.find_or_create_by!(code: code) do |code|
    code.name = name
  end
end

log "...#{logcount} modality codes seeded!"

log '-----------Adding EDTA death causes----------'

file_path = Rails.root.join('db', 'csv', 'rw_edtadeathcauses.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  code = row['code']
  cause = row['cause']
  log "   ... adding #{code}: #{cause}"
  logcount += 1
  EdtaCode.find_or_create_by!(code: code) do |code|
    code.death_cause = cause
  end
end

log "...#{logcount} EDTA death causes seeded!"


log '-----------Adding PRD terms----------'

file_path = Rails.root.join('db', 'csv', 'rw_prdcodes.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  code = row['code']
  term = row['term']
  log "   ... adding #{code}: #{term}"
  logcount += 1
  PrdCode.find_or_create_by!(code: code) do |code|
    code.term = term
  end
end

log "...#{logcount} PRD terms seeded!"

log '-----------Adding Organisms----------'

file_path = Rails.root.join('db', 'csv', 'rw_organisms.csv')

logcount=0
CSV.foreach(file_path, headers: true) do |row|
  code = row['code']
  name = row['name']
  log "   ... adding #{code}: #{name}"
  logcount += 1
  OrganismCode.find_or_create_by!(read_code: code) do |code|
    code.name = name
  end
end

log "...#{logcount} Organisms seeded!"

log 'Adding PD to HD reasons...'

PdToHaemodialysis.find_or_create_by!(rr_code: 201, description: "Patient/partner choice")
PdToHaemodialysis.find_or_create_by!(rr_code: 202, description: "Loss of supporting partner")
PdToHaemodialysis.find_or_create_by!(rr_code: 203, description: "Other change of personal circumstances")
PdToHaemodialysis.find_or_create_by!(rr_code: 204, description: "Inability to perform PD")
PdToHaemodialysis.find_or_create_by!(rr_code: 205, description: "Other reasons")
PdToHaemodialysis.find_or_create_by!(rr_code: 211, description: "Frequent/Recurrent peritonitis with or without loss of UF")
PdToHaemodialysis.find_or_create_by!(rr_code: 212, description: "Unresolving peritonitis")
PdToHaemodialysis.find_or_create_by!(rr_code: 213, description: "Catheter loss through exit site infection")
PdToHaemodialysis.find_or_create_by!(rr_code: 214, description: "Loss of UF")
PdToHaemodialysis.find_or_create_by!(rr_code: 215, description: "Inadequate clearance")
PdToHaemodialysis.find_or_create_by!(rr_code: 216, description: "Abdominal surgery or complications")

log 'Adding HD to PD reasons...'

HaemodialysisToPd.find_or_create_by!(rr_code: 221, description: "Patient/partner choice")
HaemodialysisToPd.find_or_create_by!(rr_code: 222, description: "Loss of supporting partner")
HaemodialysisToPd.find_or_create_by!(rr_code: 223, description: "Other change of personal circumstances")
HaemodialysisToPd.find_or_create_by!(rr_code: 224, description: "Lack of HD facilities")
HaemodialysisToPd.find_or_create_by!(rr_code: 225, description: "Other reasons")
HaemodialysisToPd.find_or_create_by!(rr_code: 231, description: "Loss of vascular access")
HaemodialysisToPd.find_or_create_by!(rr_code: 232, description: "Haemodynamic instability")
HaemodialysisToPd.find_or_create_by!(rr_code: 233, description: "Elective after temporary HD")

log 'Adding Medication routes...'


MedicationRoute.find_or_create_by!(name: "PO", full_name: "Per Oral")
MedicationRoute.find_or_create_by!(name: "IV", full_name: "Intravenous")
MedicationRoute.find_or_create_by!(name: "SC", full_name: "Subcutaneous")
MedicationRoute.find_or_create_by!(name: "IM", full_name: "Intramuscular")
MedicationRoute.find_or_create_by!(name: "Other (Please specify in notes)", full_name: "Other (Refer to medication notes)")


log 'Adding Peritonitis Episode Types...'

EpisodeType.find_or_create_by!(term: "De novo", definition: "First infection.")
EpisodeType.find_or_create_by!(term: "Recurrent", definition: "An episode that occurs within 4 weeks of completion of therapy of a prior episode but with a different organism.")
EpisodeType.find_or_create_by!(term: "Relapsing", definition: " An episode that occurs within 4 weeks of completion of therapy of a prior episode with the same organism or 1 sterile episode.")
EpisodeType.find_or_create_by!(term: "Repeat", definition: "An episode that occurs more than 4 weeks after completion of therapy of a prior episode with the same organism.")
EpisodeType.find_or_create_by!(term: "Refractory", definition: "Failure of the effluent to clear after 5 days of appropriate antibiotics.")
EpisodeType.find_or_create_by!(term: "Catheter-related", definition: "Peritonitis in conjunction with an exit-site or tunnel infection with the same organism or 1 site.")
EpisodeType.find_or_create_by!(term: "Other", definition: "Refer to notes.")

log 'Adding Fluid descriptions...'

FluidDescription.find_or_create_by!(description: "Clear")
FluidDescription.find_or_create_by!(description: "Misty")
FluidDescription.find_or_create_by!(description: "Cloudy")
FluidDescription.find_or_create_by!(description: "Pea Soup")

log '-----------Adding Patients----------'
file_path = Rails.root.join('db', 'csv', 'rw_patients.csv')

demo_nhsno = 1234567890
logcount=0
CSV.foreach(file_path, headers: true) do |row|
  local_patient_id = row['local_patient_id']
  demo_nhsno += 1
  log "   ... adding #{local_patient_id}"
  logcount += 1
  sex = (row['sex'] == 'M' ? 1 : 2)
  Patient.find_or_create_by!(local_patient_id: local_patient_id) do |patient|
    patient.surname = row['surname']
    patient.forename = row['forename']
    patient.sex = sex
    patient.dob = row['dob']
    patient.nhs_number = demo_nhsno
    patient.created_at = row['created_at']
  end
end

log "...#{logcount} patients seeded!"


log 'Adding RABBIT problems...'

randweeks = (0..52).to_a
file_path = Rails.root.join('db', 'csv', 'rabbit_problems.csv')
logcount=0
CSV.foreach(file_path, headers: true) do |row|
  randwk = randweeks.sample
  date = Time.now - randwk.weeks
  description = row['description']
  snomed_id = row['snomed_id ']
  log "   ... adding #{snomed_id}: #{description} from #{date}"
  logcount += 1
  PatientProblem.create(
    patient_id: 1,
    description: description,
    date: date,
    snomed_id: snomed_id)
end

log "...#{logcount} problems seeded!"

log 'Adding RABBIT events...'

PatientEvent.create(
  patient_id: 1,
  patient_event_type_id: 19,
  description: "meeting with family in clinic",
  notes: "anxious about medication changes",
  date_time: Time.now - 2.weeks
)


PatientEvent.create(
  patient_id: 1,
  patient_event_type_id: 25,
  description: "call regarding meds",
  notes: "told patient to get other drug info from GP",
  date_time: Time.now - 12.days
)

PatientEvent.create(
  patient_id: 1,
  patient_event_type_id: 8,
  description: "email re next clinic visit",
  notes: "reminded patient to bring complete drug list to clinic",
  date_time: Time.now - 5.days
)

log "...3 events seeded!"

log '-----------Database seeding complete!----------'
