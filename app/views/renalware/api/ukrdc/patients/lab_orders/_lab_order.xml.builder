# See HL7 spec http://pacs.hk/Doc/HL7/Hl7V231.pdf
#
xml = builder

xml.LabOrder do
  # xml.ReceivingLocation do
  #   xml.Code ""
  #   xml.Description # request.pathology_lab.name
  # end
  xml.PlacerId request.requestor_order_number
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
  xml.SpecimenCollectedTime request.requested_at.iso8601
  # xml.SpecimenReceivedTime "TODO"
  # xml.Priority do
  #   xml.Code "TODO: Probably n/a"
  # end
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
