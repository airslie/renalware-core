module Renalware
  log '--------------------Adding Patients--------------------'
  file_path = Rails.root.join(demo_path, 'patients.csv')

  system_user = SystemUser.find

  demo_nhsno = 1234567890
  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    local_patient_id = row['local_patient_id']
    demo_nhsno += 1
    logcount += 1

    Patient.find_or_create_by!(local_patient_id: local_patient_id) do |patient|
      patient.family_name = row['family_name']
      patient.given_name = row['given_name']
      patient.sex = row['sex']
      patient.born_on = row['born_on']
      patient.nhs_number = demo_nhsno
      patient.created_at = row['created_at']
      patient.by = system_user
    end
  end

  log "#{logcount} Patients seeded"
end
