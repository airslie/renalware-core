module Renalware
  log '--------------------Adding Problems for Roger RABBIT--------------------'

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  randweeks = (0..52).to_a
  file_path = File.join(demo_path, 'rabbit_problems.csv')
  logcount=0

  CSV.foreach(file_path, headers: true) do |row|
    randwk = randweeks.sample
    date = Time.now - randwk.weeks
    description = row['description']
    log "   ... adding #{description} from #{date}"
    logcount += 1
    Problems::Problem.find_or_create_by!(
      patient_id: rabbit.to_param,
      description: description) do |problem|
        problem.date = date
      end
  end

  log "#{logcount} Problems seeded"

  log '--------------------Adding Modalities for Roger RABBIT---------------------'

  file_path = File.join(demo_path, 'rabbit_modalities.csv')
  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    logcount += 1
    Modality.find_or_create_by!(
      patient_id: rabbit.to_param,
      modality_code_id: row['modality_code_id'],
      modality_reason_id: row['modality_reason_id']) do |mod|
        mod.modal_change_type   = row['modal_change_type']
        mod.started_on          = row['started_on']
        mod.ended_on            = row['ended_on']
      end
  end

  log "#{logcount} Modalities seeded"

  log '--------------------Adding Events for Roger RABBIT--------------------'

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

  log "3 Events seeded"

  log '--------------------Adding Doctor for Roger RABBIT---------------------'
  practice = Practice.first

  doctor = Doctor.find_or_create_by!(code: 'GP912837465') do |doc|
    doc.first_name = 'John'
    doc.last_name = 'Merrill'
    doc.email = 'john.merrill@nhs.net'
    doc.practitioner_type = 'GP'
    doc.practices << practice
  end

  rabbit.doctor = doctor
  rabbit.practice = practice
  rabbit.save!

  log '--------------------Adding Address for Roger RABBIT-------------------'
  rabbit.current_address = Address.find_or_create_by!(
    street_1: '123 South Street',
    city: 'Toontown',
    postcode: 'TT1 1HD',
    country: 'United Kingdom'
    )
  rabbit.save!

  log '--------------------Adding ClinicVisits for Roger RABBIT-------------------'
  5.times do |n|
    clinic_visit = ClinicVisit.find_or_create_by!(
      patient: rabbit,
      clinic_type: ClinicType.order("RANDOM()").first,
      height: 1.25,
      weight: 55 + n,
      systolic_bp: 110 + n,
      diastolic_bp: 68 + n,
      date: n.days.ago.change({ hour: (10 + (2 * n)), min: 0 })
    )

    rabbit.clinic_visits << clinic_visit
  end

  log '--------------------Adding Medications for Roger RABBIT-------------------'
  Medication.create([
    {patient_id: 1, medicatable_id: 986, medicatable_type: "Renalware::Drugs::Drug", treatable_id: nil, treatable_type: nil, dose: "50 mg", medication_route_id: 1, frequency: "bd for 7 days", notes: "        ", start_date: "2015-09-13", end_date: "2015-09-20", provider: 0, deleted_at: nil},
    {patient_id: 1, medicatable_id: 183, medicatable_type: "Renalware::Drugs::Drug", treatable_id: nil, treatable_type: nil, dose: "25 mg", medication_route_id: 1, frequency: "nocte", notes: "        ", start_date: "2014-10-10", end_date: nil, provider: 0, deleted_at: nil},
    {patient_id: 1, medicatable_id: 269, medicatable_type: "Renalware::Drugs::Drug", treatable_id: nil, treatable_type: nil, dose: "100 mg", medication_route_id: 1, frequency: "bd", notes: "", start_date: "2015-06-16", end_date: nil, provider: 0, deleted_at: nil},
    {patient_id: 1, medicatable_id: 126, medicatable_type: "Renalware::Drugs::Drug", treatable_id: 1, treatable_type: "Renalware::PeritonitisEpisode", dose: "100 mg", medication_route_id: 1, frequency: "tid for 7d", notes: "", start_date: "2015-09-14", end_date: "2015-09-21", provider: 0, deleted_at: nil}
  ])

  log '--------------------Adding ESRF Info for Roger RABBIT-------------------'
  ESRF.create([
    {patient_id: 1, diagnosed_on: "2015-05-05", prd_description_id: 109}
  ])

  log '--------------------Adding Exit Site Infection for Roger RABBIT-------------------'
  ExitSiteInfection.create([
    {patient_id: 1, diagnosis_date: "2015-06-09", treatment: "liquid and electrolyte replacement ", outcome: "Recovered well. Scheduled another training review session.", notes: ""}
  ])

  log '--------------------Adding Peritonitis Episode for Roger RABBIT-------------------'
  PeritonitisEpisode.create([
    {patient_id: 1, diagnosis_date: "2015-09-14", treatment_start_date: "2015-09-14", treatment_end_date: "2015-09-21", episode_type_id: 6, catheter_removed: true, line_break: false, exit_site_infection: false, diarrhoea: false, abdominal_pain: true, fluid_description_id: 4, white_cell_total: 5, white_cell_neutro: 57, white_cell_lympho: 37, white_cell_degen: 3, white_cell_other: 3, notes: ""}
  ])

  InfectionOrganism.create([
    {organism_code_id: 33, sensitivity: "+++", infectable_id: 1, infectable_type: "Renalware::PeritonitisEpisode"},
    {organism_code_id: 4, sensitivity: "unknown", infectable_id: 1, infectable_type: "Renalware::ExitSiteInfection"}
  ])
end
