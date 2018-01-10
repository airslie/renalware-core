# Here is where we configure the settings for the Renalware::Core engine.

require_dependency "renalware"

Renalware.configure do |config|
  config.patient_hospital_identifiers = {
    KCH: :local_patient_id,
    QEH: :local_patient_id_2,
    DVH: :local_patient_id_3,
    PRUH: :local_patient_id_4,
    GUYS: :local_patient_id_5
  }

  # Wire up extra listener listener to handle letter events
  map = config.broadcast_subscription_map
  map["Renalware::Letters::ApproveLetter"] = "LetterListener"
end

# Renalware::Patients.configure
# Renalware::Pathology.configure
