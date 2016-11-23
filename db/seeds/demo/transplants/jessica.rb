module Renalware
  log "Assign Live Donor modality to Jessica RABBIT" do
    patient = Patient.find_by(local_patient_id: "Z100002")
    description = Transplants::DonorModalityDescription.first!
    patient.set_modality(description: description, started_on: 1.month.ago)
  end
end
