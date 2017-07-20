xml = builder

xml.LabOrders(start: Time.zone.today.iso8601, stop: Time.zone.today.iso8601) do
  xml.comment! "Check what start and stop refer to here"

  patient.observation_requests.each do |request|
    xml.LabOrder do
      xml.ReceivingLocation do
        xml.code "TODO"
        xml.Description # request.pathology_lab.name
      end
      xml.PlacerId request.requestor_order_number
      xml.FillerId "??ORC:3 Labs Order Id"
      xml.OrderedBy do
        xml.Code "unknown"
        xml.Description request.requestor_name
      end
      xml.OrderItem do
        xml.Code "TODO LOIN code??"
      end
      xml.OrderCategory do
        xml.Code request.description.code
      end
      xml.SpecimenCollectedTime "TODO"
      xml.SpecimenReceivedTime "TODO"
      xml.Priority do
        xml.Code "TODO"
      end
      xml.SpecimenSource request.description.bottle_type
      xml.Duration "?? OBR:27.3"

      xml.ResultItems do
        request.observations.each do |observation|
          render "lab_order", observation: observation, builder: builder
        end
      end

      xml.PatientClass do
        xml.CodingStandard "HL7_0004"
        xml.Code "e.g. I for Inpatient"
        xml.Description "e.g. Inpatient?"
      end
      xml.EnteredOn request.requested_at.iso8601
      xml.EnteredAt do
        xml.code "location code here"
      end
    end
  end
end
