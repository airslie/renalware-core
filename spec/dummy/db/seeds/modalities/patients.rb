# frozen_string_literal: true

module Renalware
  log "Adding Random Modalities for non-RABBIT Patients" do
    # Note the RABBIT family have special modalities assigned elsewhere, so skip them here
    patients = Patient.all
    user_id = User.first.id
    modality_description_ids = Modalities::Description.pluck(:id) # (1..13).to_a
    months = (1..36).to_a

    Patient.transaction do
      patients.where.not(family_name: "RABBIT").all.each do |patient|
        patient.modalities.destroy_all
        patient.modalities.create!(
          patient_id: patient.id,
          description_id: modality_description_ids.sample,
          started_on: months.sample.months.ago,
          created_by_id: user_id
        )
      end
    end
  end
end
