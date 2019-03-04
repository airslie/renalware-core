# frozen_string_literal: true

# https://github.com/renalreg/ukrdc/blob/6d95e364dd8de857839fe6cdbd4e7fc3fb4c1d42/Schema/Diagnoses/Diagnosis.xsd
# This is snomed-based, so might not be possible?
xml = builder
xml.Diagnoses do
  xml.Diagnosis
  if patient.dead? && patient.first_cause.present?
    # Only 1 CauseOfDeath element is allowed so we ignore patient.second_cause
    render(
      "renalware/api/ukrdc/patients/diagnoses/cause_of_death",
      builder: xml,
      cause: patient.first_cause
    )
  end
  xml.RenalDiagnosis
end
