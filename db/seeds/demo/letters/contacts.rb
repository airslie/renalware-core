module Renalware
  log "Assign contacts to Roger RABBIT"

  patient = Letters.cast_patient(Patient.find_by(local_patient_id: "Z100001"))

  people = Directory::Person.limit(5)

  people.each do |person|
    patient.assign_contact(person: person).save!
  end
end
