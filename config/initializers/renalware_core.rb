# Here is where we configure the settings for the Renalware::Core engine.

Renalware.configure do |config|
  config.patient_hospital_identifier_map = {
    KCH: :local_patient_id,
    HOSP2: :local_patient_id_4,
    HOSP3: :local_patient_id_2,
    HOSP4: :local_patient_id_3
  }
end
