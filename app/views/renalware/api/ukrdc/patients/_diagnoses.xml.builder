# frozen_string_literal: true

# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Diagnoses/Diagnosis.xsd
# This is snomed-based, so might not be possible?
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

  if patient.prd_description_code.present?
    xml.RenalDiagnosis do
      # xml.DiagnosisType
      # xml.DiagnosingClinician
      xml.Diagnosis do
        xml.CodingStandard "EDTA2"
        xml.Code patient.prd_description_code
        xml.Description patient.prd_description_term
      end
      # xml.IdentificationTime
      # xml.OnsetTime
      # xml.EnteredOn
    end
  end
end
