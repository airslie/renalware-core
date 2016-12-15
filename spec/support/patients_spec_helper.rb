module PatientsSpecHelper
  def set_modality(patient:,
                   modality_description:,
                   started_on: Time.zone.today,
                   by: Renalware::User.first)
    patient.set_modality(description: modality_description, started_on: started_on, by: by)
    patient.attributes = { by: by }
    patient.save
    patient.reload # need to do this in order for current_modality to be set
  end
end
