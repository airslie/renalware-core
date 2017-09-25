xml = builder

xml.Medications do
  patient.prescriptions.each do |prescription|
    xml.Medication do
      xml.PrescriptionNumber
      xml.FromTime prescription.prescribed_on
      xml.ToTime prescription.terminated_on
      xml.OrderedBy
      xml.Route do
        xml.CodingStandard "RR22"
        xml.Code prescription.medication_route&.rr_code
        xml.Description prescription.medication_route&.name
      end
      xml.DrugProduct prescription.drug
      xml.Frequency prescription.frequency
      xml.Comments prescription.notes
      # xml.DoseUoM
      # xml.Indication
    end
  end
end
