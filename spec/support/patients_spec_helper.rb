# frozen_string_literal: true

module PatientsSpecHelper
  def set_modality(patient:,
                   modality_description:,
                   started_on: Time.zone.today,
                   by: Renalware::User.first)

    # ChangePatientModality returns a Success or Failure object
    new_modality = Renalware::Modalities::ChangePatientModality
      .new(patient: patient, user: by)
      .call(
        description: modality_description,
        started_on: started_on
      )

    patient.reload # need to do this in order for current_modality to be set

    # Return ther object associated with the returned Success or Failure object
    new_modality.object
  end
end
