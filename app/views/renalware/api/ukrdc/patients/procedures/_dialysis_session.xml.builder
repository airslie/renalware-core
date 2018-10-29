# frozen_string_literal: true

xml = builder

xml.DialysisSession(
  start: session.start_datetime&.to_datetime,
  stop: session.stop_datetime&.to_datetime
) do
  xml.QHD19 session.had_intradialytic_hypotension?
  xml.QHD20 session.access_type
  xml.QHD21 session.access_side
  xml.QHD22 # Access in two sites simultaneously
  xml.QHD30 session.blood_flow
  xml.QHD31 session.duration_in_minutes # Time Dialysed in Minutes
  xml.QHD32 session.sodium_content # Sodium in Dialysate
  xml.QHD33 # Needling Method

  # xml.EncounterNumber session.uuid
  # xml.EncounterType "R"
  # xml.FromTime session.start_datetime&.to_datetime
  # xml.ToTime session.stop_datetime&.to_datetime

  # xml.HealthCareFacility do
  #   xml.CodingStandard "ODS"
  #   xml.Code session.hospital_unit_renal_registry_code
  #   xml.Description session.hospital_unit_name
  # end

  # xml.AdmitReason do
  #   xml.comment! "AdmitReason 1 == Haemodialysis - TBC - may need to capture/derive"
  #   xml.CodingStandard "CF_RR7_TREATMENT"
  #   xml.Code "1"
  # end

  # xml.EnteredAt do
  #   xml.Code session.hospital_unit_renal_registry_code
  # end

  # xml.Attributes do
  #   xml.HDP01 session.patient&.hd_profile&.schedule_definition&.days_per_week
  #   xml.HDP02 session.duration
  #   xml.HDP03 session.document.dialysis.flow_rate
  #   xml.HDP04 session&.dialysate&.sodium_content
  #   xml.QBL05 session.access_type
  #   xml.comment! "ERF61 - defaulting to 5 if not present, as element is required"
  #   xml.ERF61 patient.current_registration_status_rr_code || "5" # 5= not assessed
  #   xml.PAT35 patient.first_seen_on
  # end
end
