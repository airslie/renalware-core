# frozen_string_literal: true

xml = builder

xml.Medications do
  patient.prescriptions.each do |prescription|
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


      # rubocop:disable Style/RescueModifier
      # Only output DoseQuantity is it is an integer or decimal
      dose_amount_is_a_number = Float(prescription.dose_amount) rescue nil
      # rubocop:enable Style/RescueModifier
      if dose_amount_is_a_number
        xml.DoseQuantity prescription.dose_amount
      end

      if prescription.dose_unit.present?
        xml.DoseUoM do
          prescription.dose_unit
          xml.CodingStandard "LOCAL"
          xml.Code prescription.dose_unit&.text
          xml.Description prescription.dose_unit
        end
      end
    end
  end
end
