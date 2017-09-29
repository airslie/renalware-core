xml = builder

xml.Treatment do
  xml.EncounterNumber "?can supply uuid if required?"
  xml.comment! "What EncounterType for HD Session?"
  xml.EncounterType "R"
  xml.FromTime session.start_datetime&.to_datetime
  xml.ToTime session.stop_datetime&.to_datetime
  xml.HealthCareFacility
  xml.EnteredAt do
    xml.Code session.hospital_unit.renal_registry_code
  end

  xml.Attributes do
    xml.HDP01 "Times per week - to confirm"
    xml.HDP02 session.duration
    xml.HDP03 session.document.dialysis.flow_rate
    xml.comment! "HDP04 Sodium in Dialysate - to follow."
    xml.HDP04 ""
    xml.QBL05 session.access_type
    xml.QBL06 ""
    xml.comment! "QBL06 HD Shared Care - not implemented yet"
    xml.QBL07 ""
    xml.comment! "QBL07 HD Shared Care - not implemented yet"
    xml.comment! "ERF61 value to confirm (Assessed for suitability for Transplant "\
                 "by start of Dialysis Date - see "\
                 "https://github.com/renalreg/ukrdc/blob/master/Schema/Encounters/Treatment.xsd"
    xml.ERF61 "5"
    xml.PAT35 patient.first_seen_on
  end
  xml.comment! "TODO: AdmitReason fails xsd validation with "\
             "Element 'AdmitReason': This element is not expected. Expected is one of "\
             "( VisitDescription, Attributes, UpdatedOn, ActionCode, ExternalId )."
  # xml.AdmitReason do
  #   xml.comment! "I think AdmitReason 1 is Haemodialysis"
  #   xml.CodingStandard "CF_RR7_TREATMENT"
  #   xml.Code "1"
  # end
  # xml.UpdatedOn
  # xml.ActionCode
  # xml.ExternalId
end
