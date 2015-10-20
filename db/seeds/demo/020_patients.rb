module Renalware
  log '--------------------Adding Patients--------------------'
  file_path = Rails.root.join(demo_path, 'patients.csv')

  demo_nhsno = 1234567890
  logcount=0
  CSV.foreach(file_path, headers: true) do |row|
    local_patient_id = row['local_patient_id']
    demo_nhsno += 1
    logcount += 1
    sex = (row['sex'] == 'M' ? "Male" : "Female")

    Patient.find_or_create_by!(local_patient_id: local_patient_id) do |patient|
      patient.surname = row['surname']
      patient.forename = row['forename']
      patient.sex = sex
      patient.birth_date = row['birth_date']
      patient.nhs_number = demo_nhsno
      patient.created_at = row['created_at']
    end
  end

  log "#{logcount} Patients seeded"
end