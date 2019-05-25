# frozen_string_literal: true

# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Diagnoses/Diagnosis.xsd
xml = builder
xml.Diagnoses do
  if patient.dead? && patient.first_cause.present?
    # Only 1 CauseOfDeath element is allowed so we ignore patient.second_cause
    render(
      "renalware/api/ukrdc/patients/diagnoses/cause_of_death",
      builder: xml,
      cause: patient.first_cause
    )
  end

  patient.yes_comorbidities.each do |comorb|
    xml.Diagnosis do
      xml.Diagnosis do
        xml.CodingStandard "SNOMED"
        xml.Code comorb.code
        xml.Description comorb.name
      end

      # If no date (or year) is associated with the comorbidity then
      # use the esrf date. See email from GS to TC 23/5/18.
      onset_date = comorb.date || patient.esrf_on
      xml.OnsetTime(onset_date) if onset_date.present?
    end
  end

  if patient.smoking_history?
    xml.Diagnosis do
      xml.Diagnosis do
        xml.CodingStandard "SNOMED"
        xml.Code patient.snomed_smoking_history.code
        xml.Description "Smoking history: #{patient.snomed_smoking_history.description}"
      end
      # We don't store a smoking date (it doesn't make much sense to) but UKRDC
      # would like a date so send th ESRF date. See email from GS to TC 23/5/18.
      xml.OnsetTime(patient.esrf_on) if patient.esrf_on.present?
    end
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
