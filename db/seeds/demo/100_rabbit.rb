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
    Modalities::Modality.find_or_create_by!(
      patient_id: rabbit.to_param,
      description_id: row['description'],
      reason_id: row['reason_id']) do |mod|
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
    doc.given_name = 'John'
    doc.family_name = 'Merrill'
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
    user = User.first
    clinic_visit = ClinicVisit.find_or_create_by!(
      patient: rabbit,
      clinic: Clinic.order("RANDOM()").first,
      height: 1.25,
      weight: 55 + n,
      systolic_bp: 110 + n,
      diastolic_bp: 68 + n,
      date: n.days.ago.change({ hour: (10 + (2 * n)), min: 0 }),
    ) do |cv|
      cv.by = user
    end
  end

  log '--------------------Adding Medications for Roger RABBIT-------------------'
  Medication.create([
    {patient_id: 1, drug_id: 986, treatable_id: 1, treatable_type: "Renalware::Patient", dose: "50 mg", medication_route_id: 1, frequency: "bd for 7 days", start_date: "2015-09-13", end_date: "2015-09-20", provider: 0},
    {patient_id: 1, drug_id: 183, treatable_id: 1, treatable_type: "Renalware::Patient", dose: "25 mg", medication_route_id: 1, frequency: "nocte", start_date: "2014-10-10", end_date: nil, provider: 0},
    {patient_id: 1, drug_id: 269, treatable_id: 1, treatable_type: "Renalware::Patient", dose: "100 mg", medication_route_id: 1, frequency: "bd", start_date: "2015-06-16", end_date: nil, provider: 0},
    {patient_id: 1, drug_id: 126, treatable_id: 1, treatable_type: "Renalware::PeritonitisEpisode", dose: "100 mg", medication_route_id: 1, frequency: "tid for 7d", start_date: "2015-09-14", end_date: "2015-09-21", provider: 0}
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

  log '--------------------Assign Live Donor modality to Jessica RABBIT-------------------'
  patient = Patient.find_by(local_patient_id: "Z100002")
  description = Modalities::Description.find_by(code: "livedonor")
  patient.set_modality(description: description, started_on: 1.month.ago)

  log '--------------------Assign Unit HD modality to Francois RABBIT-------------------'
  patient = Patient.find_by(local_patient_id: "Z100003")
  description = Modalities::Description.find_by(code: "HD_unit")
  patient.set_modality(description: description, started_on: 1.week.ago)

  log '--------------------Assign some HD preferences to Francois RABBIT-------------------'
  preference_set = HD::PreferenceSet.find_or_initialize_by(patient: patient)
  preference_set.attributes = { schedule: "mon_wed_fri_am", entered_on: 1.week.ago.to_date, by: User.first }
  preference_set.save!

  log '--------------------Assign an HD profile to Francois RABBIT-------------------'
  profile = HD::Profile.find_or_initialize_by(patient: patient)
  profile.attributes = {
    by: User.first,
    hospital_unit: Hospitals::Unit.hd_sites.first,
    schedule: "mon_wed_fri_am",
    prescribed_time: 150,
    prescribed_on: 1.week.ago.to_date,
    prescriber: User.first,
    named_nurse: User.last,
    transport_decider: User.first,
    document: {
      dialysis: {
        hd_type: :hd,
        cannulation_type: "Buttonhole",
        needle_size: "44",
        single_needle: :yes,
        dialysate: :a7,
        flow_rate: 300,
        blood_flow: 400,
        dialyser: "FX CorDiax 120",
        potassium: 2,
        calcium: 1.5,
        temperature: 36.0,
        bicarbonate: 35,
        has_sodium_profiling: :no,
        sodium_first_half: 137,
        sodium_second_half: 145
      },
      anticoagulant: {
        type: :heparin,
        loading_dose: 45,
        hourly_dose: 66,
        stop_time: "0:45",
      },
      drugs: {
        on_esa: :no,
        on_iron: :no,
        on_warfarin: :no
      },
      transport: {
        has_transport: :yes,
        type: :taxi,
        decided_on: 2.days.ago.to_date,
      },
      care_level: {
        required: :no,
        assessed_on: 3.days.ago.to_date
      }
    }
  }
  profile.save!

  log '--------------------Assign HD sessions to Francois RABBIT-------------------'
  units = Hospitals::Unit.hd_sites.limit(3).to_a
  users = User.limit(3).to_a
  start_times = ["13:00", "13:15", "13:30"]
  end_times = ["15:30", "15:45", "16:00"]
  20.times do |i|
    session = HD::Session.new(
      patient: patient,
      hospital_unit: units.sample,
      performed_on: (i*2).days.ago,
      start_time: start_times.sample,
      end_time: end_times.sample,
      signed_on_by: users.sample,
      signed_off_by: users.sample,
      by: users.sample
    )
    if i == 0
      session.end_time = nil
      session.signed_off_by = nil
    end
    session.save!
  end
end
