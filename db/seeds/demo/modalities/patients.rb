module Renalware
  log "Adding Random Modalities for non-RABBIT Patients"
  # note RABBIT family have special modalities assigned
  patients = Patient.all
  modal_ids = (1..15).to_a
  months = (1..36).to_a
  patients.each do |patient|
    if patient.family_name != "RABBIT"
      patient.modalities.destroy_all
      patient.modalities.create!(
        patient_id: patient.id,
        description_id: modal_ids.sample,
        started_on: months.sample.months.ago)
    end
  end
end
