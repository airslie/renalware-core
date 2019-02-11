# frozen_string_literal: true

module Renalware
  log "Adding Random Modalities for non-RABBIT Patients" do
    # Note the RABBIT family have special modalities assigned elsewhere, so skip them here
    patient_ids = Patient.where.not(family_name: "RABBIT").pluck(:id)
    user_id = User.first.id
    modality_description_ids = Modalities::Description.pluck(:id)
    months = (1..36).to_a

    modalities = []

    # Remove any current modalities
    Modalities::Modality.where(patient_id: patient_ids).delete_all

    patient_ids.each do |patient_id|
      modalities << Modalities::Modality.new(
        patient_id: patient_id,
        description_id: modality_description_ids.sample,
        started_on: months.sample.months.ago,
        created_by_id: user_id,
        updated_by_id: user_id
      )
    end
    Modalities::Modality.import! modalities
  end
end
