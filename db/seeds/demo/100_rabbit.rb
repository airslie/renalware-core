module Renalware
  log '--------------------Adding Problems for Roger RABBIT--------------------'

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')

  randweeks = (0..52).to_a
  file_path = File.join(demo_path, 'rabbit_problems.csv')
  logcount=0

  Problems::Problem.where(patient_id: rabbit.id).destroy_all

  CSV.foreach(file_path, headers: true) do |row|
    randwk = randweeks.sample
    date = Time.now - randwk.weeks
    description = row['description']
    log "   ... adding #{description} from #{date}"
    logcount += 1
    Problems::Problem.create!(
      patient_id: rabbit.to_param,
      description: description,
      date: date,
      position: logcount
    )
  end

  log "#{logcount} Problems seeded"

  log '--------------------Adding Problem Notes for Roger RABBIT--------------------'

  rabbit = Patient.find_by(family_name: 'RABBIT', given_name: 'Roger')
  problem_ids = Problems::Problem.where(patient_id: rabbit.id).pluck(:id)
  users = User.limit(3).to_a

  file_path = File.join(demo_path, 'rabbit_problem_notes.csv')
  logcount=0

  CSV.foreach(file_path, headers: true) do |row|
    description = row['description']
    problem_index = row['problem_index'].to_i
    logcount += 1
    Problems::Note.find_or_create_by!(
      problem_id: problem_ids[problem_index],
      description: description
    ) do |note|
      note.by = users.sample
    end
  end

  log "#{logcount} Problem Notes seeded"

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
  system_user = SystemUser.find

  doctor = Doctor.find_or_create_by!(code: 'GP912837465') do |doc|
    doc.given_name = 'John'
    doc.family_name = 'Merrill'
    doc.email = 'john.merrill@nhs.net'
    doc.practitioner_type = 'GP'
    doc.practices << practice
  end

  rabbit.doctor = doctor
  rabbit.practice = practice
  rabbit.by = system_user
  rabbit.save!

  log '--------------------Adding Address for Roger RABBIT-------------------'
  rabbit.current_address = Address.find_or_create_by!(
    name: "M. Roger Rabbit",
    street_1: '123 South Street',
    city: 'Toontown',
    postcode: 'TT1 1HD',
    country: 'United Kingdom'
    )
  rabbit.by = system_user
  rabbit.save!

  log '--------------------Adding ClinicVisits for Roger RABBIT-------------------'
  5.times do |n|
    user = User.first
    clinic_visit = Clinics::ClinicVisit.find_or_create_by!(
      patient: Clinics.cast_patient(rabbit),
      clinic: Clinics::Clinic.order("RANDOM()").first,
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

  log '--------------------Assign Access procedure to Francois RABBIT-------------------'
  patient = ActiveType.cast(Patient.find_by(local_patient_id: "Z100003"), Accesses::Patient)
  patient.procedures.destroy_all
  users = User.limit(3).to_a
  procedure1 = patient.procedures.create!(
    performed_on: 6.months.ago,
    type: Accesses::Type.all.sample,
    site: Accesses::Site.all.sample,
    side: Accesses::Profile.side.values.sample,
    performed_by: users.sample,
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    outcome: "Perfect",
    by: users.sample
  )
  procedure2 = patient.procedures.create!(
    performed_on: 3.months.ago,
    type: Accesses::Type.all.sample,
    site: Accesses::Site.all.sample,
    side: Accesses::Profile.side.values.sample,
    performed_by: users.sample,
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    outcome: "Perfect",
    by: users.sample
  )

  log '--------------------Assign Access profiles to Francois RABBIT-------------------'
  patient = ActiveType.cast(Patient.find_by(local_patient_id: "Z100003"), Accesses::Patient)
  patient.profiles.destroy_all
  users = User.limit(3).to_a

  patient.profiles.create!(
    formed_on: procedure1.performed_on,
    planned_on: (procedure1.performed_on + 5.days),
    started_on: (procedure1.performed_on - 2.months),
    terminated_on: 1.month.ago,
    type: procedure1.type,
    site: procedure1.site,
    side: procedure1.side,
    plan: Accesses::Plan.all.sample,
    decided_by: users.sample,
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    by: users.sample
  )

  patient.profiles.create!(
    patient: patient,
    formed_on: procedure2.performed_on,
    planned_on: (procedure2.performed_on + 5.days),
    started_on: (procedure2.performed_on - 2.months),
    type: procedure2.type,
    site: procedure2.site,
    side: procedure2.side,
    plan: Accesses::Plan.all.sample,
    decided_by: users.sample,
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    by: users.sample
  )

  patient.profiles.create!(
    patient: patient,
    formed_on: 1.week.ago,
    planned_on: 2.weeks.ago,
    type: Accesses::Type.all.sample,
    site: Accesses::Site.all.sample,
    side: Accesses::Profile.side.values.sample,
    plan: Accesses::Plan.where(name: "Fistula/graft maturing").first,
    decided_by: users.sample,
    notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    by: users.sample
  )

  log '--------------------Assign Access assessments to Francois RABBIT-------------------'
  patient = ActiveType.cast(Patient.find_by(local_patient_id: "Z100003"), Accesses::Patient)
  patient.assessments.destroy_all
  patient.assessments.create!(
    patient: patient,
    performed_on: procedure1.performed_on + 1.month,
    procedure_on: procedure1.performed_on,
    type: procedure1.type,
    site: procedure1.site,
    side: procedure1.side,
    comments: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    by: users.sample,
    document: {
      results: {
        method: :hand_doppler,
        flow_feed_artery: "abcdef" ,
        has_art_stenosis: :no,
        art_stenosis_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        has_ven_stenosis: :yes,
        ven_stenosis_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        has_residual_stenosis: :no,
        outcome: :green
      },
      admin: {
        next_surveillance: :routine_monthly,
        decision: "Continue"
      }
    }
  )

  patient.assessments.create!(
    patient: patient,
    performed_on: procedure2.performed_on + 1.month,
    procedure_on: procedure2.performed_on,
    type: procedure2.type,
    site: procedure2.site,
    side: procedure2.side,
    comments: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    by: users.sample,
    document: {
      results: {
        method: :hand_doppler,
        flow_feed_artery: "abcdef" ,
        has_art_stenosis: :no,
        art_stenosis_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        has_ven_stenosis: :yes,
        ven_stenosis_notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
        has_residual_stenosis: :no,
        outcome: :green
      },
      admin: {
        next_surveillance: :routine_monthly,
        decision: "Continue"
      }
    }
  )

  log '--------------------Assign Letters to Roger RABBIT-------------------'
  patient = ActiveType.cast(Patient.find_by(local_patient_id: "Z100001"), Letters::Patient)
  patient.letters.destroy_all
  users = User.limit(3).to_a

  letter_body = <<-TEXT
    Cras justo odio, dapibus ac facilisis in, egestas eget quam. Curabitur blandit tempus porttitor. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Nullam id dolor id nibh ultricies vehicula ut id elit. Nulla vitae elit libero, a pharetra augue. Nulla vitae elit libero, a pharetra augue.

    Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Sed posuere consectetur est at lobortis. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Curabitur blandit tempus porttitor. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam id dolor id nibh ultricies vehicula ut id elit.

    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Etiam porta sem malesuada magna mollis euismod. Donec ullamcorper nulla non metus auctor fringilla.

    Yours sincerely
    TEXT

  Letters::Letter::Draft.create!(
    patient: patient,
    issued_on: 1.day.ago,
    description: Renalware::Letters::Description.first.text,
    salutation: "Dear Dr Runner",
    main_recipient_attributes: {
      person_role: "doctor"
    },
    body: letter_body,
    notes: "Waiting on lab results.",
    letterhead: Renalware::Letters::Letterhead.first,
    author: users.sample,
    by: users.sample
  )

  Letters::Letter::Typed.create!(
    patient: patient,
    issued_on: 3.days.ago,
    description: Renalware::Letters::Description.last.text,
    main_recipient_attributes: {
      person_role: "patient"
    },
    salutation: "Dear Mr Rabbit",
    body: letter_body,
    letterhead: Renalware::Letters::Letterhead.last,
    author: users.sample,
    by: users.sample
  )

  archived_letter = Letters::Letter::Archived.create!(
    patient: patient,
    issued_on: 10.days.ago,
    description: Renalware::Letters::Description.last.text,
    main_recipient_attributes: {
      person_role: "patient"
    },
    salutation: "Dear Mr Rabbit",
    body: letter_body,
    letterhead: Renalware::Letters::Letterhead.last,
    author: users.sample,
    by: users.sample
  )

  archived_letter.main_recipient.build_address.tap do |address|
    address.copy_from(archived_letter.patient.current_address)
    address.save!
  end
  recipient = archived_letter.cc_recipients.create(person_role: "doctor")
  recipient.build_address.tap do |address|
    address.copy_from(archived_letter.patient.doctor.current_address)
    address.save!
  end
end
