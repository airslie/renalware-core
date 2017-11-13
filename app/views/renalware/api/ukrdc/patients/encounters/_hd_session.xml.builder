xml = builder

xml.Treatment do
  xml.EncounterNumber session.uuid
  xml.comment! "TODO: EncounterType TBC"
  xml.EncounterType "R"
  xml.FromTime session.start_datetime&.to_datetime
  xml.ToTime session.stop_datetime&.to_datetime

  xml.HealthCareFacility do
    xml.CodingStandard "ODS"
    xml.Code session.hospital_unit_renal_registry_code
    xml.Description session.hospital_unit_name
  end

  xml.AdmitReason do
    xml.comment! "AdmitReason 1 == Haemodialysis - TBC - may need to capture/derive"
    xml.CodingStandard "CF_RR7_TREATMENT"
    xml.Code "1"
  end

  xml.EnteredAt do
    xml.Code session.hospital_unit.renal_registry_code
  end

  xml.Attributes do
    xml.HDP01 hd_patient&.hd_profile&.schedule_definition&.days_per_week
    xml.HDP02 session.duration
    xml.HDP03 session.document.dialysis.flow_rate
    xml.HDP04 session&.dialysate&.sodium_content
    xml.QBL05 session.access_type
    xml.comment! "QBL06 HD Shared Care - including as XSD requires it, but not implemented yet"
    xml.QBL06 ""
    xml.comment! "QBL07 HD Shared Care - including as XSD requires it, but not implemented yet"
    xml.QBL07 ""
    xml.comment! "ERF61 - defaulting to 5 if not present, as element is required"
    xml.ERF61 patient.current_registration_status_rr_code || "5" # 5= not assessed
    xml.PAT35 patient.first_seen_on
  end

  # xml.UpdatedOn
  # xml.ActionCode
  # xml.ExternalId
end
