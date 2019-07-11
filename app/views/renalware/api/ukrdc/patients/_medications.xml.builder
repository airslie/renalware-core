# frozen_string_literal: true

xml = builder

xml.Medications do
  patient.prescriptions_with_numeric_dose_amount.each do |prescription|
    xml.Medication do
      xml.FromTime prescription.prescribed_on.to_datetime
      if prescription.terminated_or_marked_for_termination?
        xml.ToTime prescription.terminated_on&.to_datetime
      end
      xml.Route do
        xml.CodingStandard "RR22"
        xml.Code prescription.medication_route&.rr_code
        xml.Description prescription.medication_route&.name
      end
      xml.DrugProduct do
        xml.Generic prescription.drug
        # xml.Id do
        #   xml.CodingStandard "DM+D"
        #   xml.Code "dm + d code for the drug - coming soon"
        #   xml.Description prescription.drug
        # end
      end
      xml.Frequency prescription.frequency
      xml.Comments [prescription.dose_amount,
                    prescription.dose_unit&.text,
                    prescription.frequency].compact.join(" ")
      xml.DoseQuantity prescription.dose_amount&.strip

      if prescription.dose_unit.present?
        xml.DoseUoM do
          prescription.dose_unit
          xml.CodingStandard "LOCAL"
          xml.Code prescription.dose_unit&.text
          xml.Description prescription.dose_unit
        end
      end

      xml.ExternalId prescription.id
    end
  end
end
