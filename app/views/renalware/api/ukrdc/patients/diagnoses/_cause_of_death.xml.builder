# frozen_string_literal: true

xml = builder

# temp hack until XSD updated to include missing code 34
cause_code = cause.code
cause_code = 99 if cause_code == 34

xml.CauseOfDeath do
  xml.DiagnosisType "final"
  xml.Diagnosis do
    xml.CodingStandard "EDTA_COD"
    xml.Code cause_code
  end
  xml.EnteredOn cause.created_at.to_datetime
end
