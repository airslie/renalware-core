module PatientsSpecHelper
  def set_modality(patient:,
                   modality_description:,
                   started_on: Time.zone.today,
                   by: Renalware::User.first)

    Renalware::Modalities::ChangePatientModality
      .new(patient: patient, user: by)
      .call(
        description: modality_description,
        started_on: started_on
      )

    patient.reload # need to do this in order for current_modality to be set
  end
end
