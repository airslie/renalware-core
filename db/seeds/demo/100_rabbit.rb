module Renalware
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
      snomed_id: snomed_id) do |problem|
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
        mod.start_date          = row['start_date']
        mod.termination_date    = row['termination_date']
        mod.deleted_at          = row['deleted_at']
        mod.created_at          = row['created_at']
        mod.updated_at          = row['updated_at']
      end
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
  rabbit.current_address = Address.find_or_create_by!(street_1: '123 South Street',
                                                      city: 'Toontown',
                                                      postcode: 'TT1 1HD',
                                                      country: 'United Kingdom')
  rabbit.save!


  log '--------------------Adding ClinicVisits for Roger RABBIT-------------------'
  5.times do |n|
    rabbit.clinic_visits << ClinicVisit.find_or_create_by!(
      patient: rabbit, height: 1.25, weight: 55 + n, systolic_bp: 110 + n, diastolic_bp: 68 + n) do |clinic|
        clinic.date = n.days.ago.change({ hour: (10 + (2 * n)), min: 0 })
      end
  end
end