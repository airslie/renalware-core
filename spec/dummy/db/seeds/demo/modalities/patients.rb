module Renalware
  log "Adding Random Modalities for non-RABBIT Patients" do
    # note RABBIT family have special modalities assigned
    Patient.transaction do
      patients = Patient.all
      modal_ids = (1..13).to_a
      months = (1..36).to_a
      patients.each do |patient|
        if patient.family_name != "RABBIT"
          patient.modalities.destroy_all
          patient.modalities.create!(
            patient_id: patient.id,
            description_id: modal_ids.sample,
            started_on: months.sample.months.ago,
            created_by_id: Renalware::User.first.id)
        end
      end
    end
  end
end
