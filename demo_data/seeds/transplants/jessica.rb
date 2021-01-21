# frozen_string_literal: true

module Renalware
  log "Assign Live Donor modality to Jessica RABBIT" do
    patient = Patient.find_by(local_patient_id: "Z100002")

    Modalities::ChangePatientModality
      .new(patient: patient, user: User.first)
      .call(
        description: Transplants::DonorModalityDescription.first!,
        started_on: 1.month.ago
      )
  end
end
