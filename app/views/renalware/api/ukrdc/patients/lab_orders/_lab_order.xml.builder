# frozen_string_literal: true

# See HL7 spec http://pacs.hk/Doc/HL7/Hl7V231.pdf

# A Note about PlacerId
# ---------------------
# In UKRDC terms an OBR equates to their LabOrder. Each LabOrder must have a unique
# PlacerId. However an HL7 message (for example at KCH) can have multiple OBRs with the same
# placer id (aka requester order number) thus causing duplicate placer ids to appear in the XML.
# After email discussion with George and Nick at UKRDC it was decided that PlacerID could be
# any value as long as it is unique and is persisted in Renalware (in case an update needs to be
# sent, and the original LabOrder identified). To solve this we obfuscate the request.id (slightly)
# by converting to base 16 (hex) and then append it to the original requester order number.
# Its not good practice to expose a database id in this way though it is to an internal NHS consumer
# and the hex obfuscation helps slightly.
# A better approach might be to generate a GUID for each pathology_observation_request and pass
# this as the placer id. However that would introduce more moving parts (calling the SQL function
# to generate the uuid) and increases storage and XML file sizes.
placer_id = "#{request.requestor_order_number}-#{request.id.to_s(16)}".upcase

xml = builder

xml.LabOrder do
  # xml.ReceivingLocation do
  #   xml.Code ""
  #   xml.Description # request.pathology_lab.name
  # end
  xml.PlacerId placer_id
  # xml.FillerId "??ORC:3 Labs Order Id"
  # xml.OrderedBy do
  #   xml.Code "unknown"
  #   xml.Description request.requestor_name
  # end
  # xml.OrderItem do
  #   xml.comment! "Code TODO: LOIN code for request E.g. MB from 'OBR|1|^PCS|09B0099478^LA|FBC^FULL BLOOD COUNT^MB|..'"
  #   xml.Code
  # end
  xml.OrderCategory do
    xml.Code request.description.code
  end
  xml.SpecimenCollectedTime request.requested_at&.iso8601
  # xml.SpecimenReceivedTime "TODO"
  xml.SpecimenSource request.description.bottle_type
  # xml.Duration "OBR:27.3 but no available in the example messages I have"

  xml.ResultItems do
    render partial: "renalware/api/ukrdc/patients/lab_orders/result_item",
           collection: request.observations,
           as: :observation,
           locals: { builder: builder, patient: patient }
  end

  # xml.PatientClass do
  #   xml.CodingStandard "HL7_0004"
  #   xml.Code "e.g. I for Inpatient"
  #   xml.Description "e.g. Inpatient"
  # end
  xml.EnteredOn request.requested_at.iso8601
  # xml.EnteredAt do
  #   xml.code "location code here"
  # end
end
