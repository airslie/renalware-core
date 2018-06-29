# frozen_string_literal: true

xml = builder

xml.CauseOfDeath do
  xml.DiagnosisType "final"
  xml.Diagnosis do
    xml.CodingStandard "EDTA"
    xml.Code cause.code
  end
  xml.EnteredOn cause.created_at.to_datetime
end
