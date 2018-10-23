# frozen_string_literal: true

xml = builder

xml.Documents do
  patient.letters.each do |letter|
    xml.Document do
      xml.DocumentTime letter.issued_on.to_time.iso8601
      xml.Clinician do
        xml.CodingStandard "LOCAL"
        xml.Code letter.author.username
        xml.Description letter.author.to_s
      end
      xml.DocumentName letter.title
      xml.Status do
        xml.Code "ACTIVE"
      end
      xml.EnteredBy do
        xml.CodingStandard "LOCAL"
        xml.Code letter.updated_by&.username
        xml.Description letter.updated_by
      end
      xml.EnteredAt do
        xml.CodingStandard "ODS"
        xml.Code letter.hospital_unit_code
        xml.Description ""
      end
      xml.FileType "application/pdf"
      xml.FileName letter.pdf_stateless_filename
      xml.Stream Base64.encode64(Renalware::Letters::PdfRenderer.call(letter))
      xml.DocumentURL
    end
  end
end
