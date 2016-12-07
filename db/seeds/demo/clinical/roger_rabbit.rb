module Renalware
  #log "Assign Allergies to Roger RABBIT" do
    patient = Clinical.cast_patient(Patient.find_by(local_patient_id: "Z100001"))
    patient.allergies.create(description: "Carrots", recorded_at: Time.zone.now)
  #end
end
