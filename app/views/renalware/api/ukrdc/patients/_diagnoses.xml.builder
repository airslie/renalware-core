# frozen_string_literal: true

# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Diagnoses/Diagnosis.xsd
xml = builder
xml.Diagnoses do
  patient.yes_comorbidities.each do |comorb|
    xml.Diagnosis do
      xml.Diagnosis do
        xml.CodingStandard "SNOMED"
        xml.Code comorb.code
        xml.Description comorb.name
      end

      # See email from GS to TC 23/5/18 regarding dates.
      # UKRDC would like to receive a date so if no onset date stored in RW for the comorbidity,
      # send the esrf date as the identification date
      if comorb.date.present?
        xml.OnsetTime comorb.date
      elsif patient.esrf_on.present?
        xml.IdentificationTime patient.esrf_on
      end
    end
  end

  if patient.smoking_cormbidity&.value.present?
    xml.Diagnosis do
      xml.Diagnosis do
        xml.CodingStandard "SNOMED"
        xml.Code patient.smoking_cormbidity.snomed_code
        xml.Description "Smoking history: #{patient.smoking_cormbidity.snomed_description}"
      end
      # We don't store a smoking date (it doesn't make much sense to) but UKRDC
      # would like a date so send th ESRF date. See email from GS to TC 23/5/18.
      xml.IdentificationTime(patient.esrf_on) if patient.esrf_on.present?
    end
  end

  if patient.dead? && patient.first_cause.present?
    # Only 1 CauseOfDeath element is allowed so we ignore patient.second_cause
    render(
      "renalware/api/ukrdc/patients/diagnoses/cause_of_death",
      builder: xml,
      cause: patient.first_cause
    )
  end

  if patient.prd_description_code.present?
    xml.RenalDiagnosis do
      xml.Diagnosis do
        xml.CodingStandard "EDTA2"
        xml.Code patient.prd_description_code
        xml.Description patient.prd_description_term
      end
      xml.IdentificationTime(patient.first_seen_on) if patient.first_seen_on.present?
    end
  end
end
