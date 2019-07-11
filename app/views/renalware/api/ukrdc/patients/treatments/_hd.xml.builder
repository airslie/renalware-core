# frozen_string_literal: true

xml = builder

xml.Treatment do
  xml.EncounterNumber [treatment.modality_id, treatment.hd_profile_id].compact.join("-")
  xml.EncounterType "N"
  xml.FromTime treatment.started_on&.iso8601
  xml.ToTime(treatment.ended_on&.iso8601) if treatment.ended_on.present?

  if treatment.hospital_unit.present?
    xml.HealthCareFacility do
      xml.CodingStandard "ODS"
      xml.Code treatment.hospital_unit.renal_registry_code
    end
  end

  xml.AdmitReason do
    xml.CodingStandard "CF_RR7_TREATMENT"
    xml.Code treatment.modality_code.txt_code
  end

  # HD
  rr8 = treatment.hospital_unit&.unit_type_rr8
  if rr8.present?
    xml.Attributes do
      xml.QBL05 rr8 # eg HOME
    end
  end
end
