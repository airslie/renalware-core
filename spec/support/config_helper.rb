module ConfigHelper
  # This represents the order of preference of local_patient_ids database columns and also
  # their 'display names' for use e.g. in the patient banner
  def configure_patient_hospital_identifiers
    # Note mixing up the order here is intentional
    allow(Renalware.config).to receive(:patient_hospital_identifiers).and_return(
      HOSP1: :local_patient_id,
      HOSP2: :local_patient_id_4,
      HOSP3: :local_patient_id_2,
      HOSP4: :local_patient_id_3,
      HOSP5: :local_patient_id_5
    )
  end
end
