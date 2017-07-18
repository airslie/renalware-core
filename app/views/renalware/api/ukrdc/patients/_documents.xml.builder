xml = builder

xml.Documents do
  patient.letters.each do |letter|
    xml.Document do
      xml.DocumentTime letter.created_at.iso8601
      xml.DocumentName letter.title
      xml.Clinician do
        xml.Description
      end
      xml.Location do
        xml.Code letter.hospital_unit_code
      end
      xml.Status do
        xml.Code "ACTIVE"
      end
      xml.EnteredBy do
        xml.Description letter.updated_by
      end
      xml.EnteredAt do
        xml.Code letter.hospital_unit_code
      end
      xml.FileType do
        xml.Code "PDF"
      end
      xml.Stream Base64.encode64(Renalware::Letters::PdfRenderer.call(letter))
    end
  end
end
