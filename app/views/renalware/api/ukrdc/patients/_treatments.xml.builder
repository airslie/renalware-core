# frozen_string_literal: true

xml = builder

# A temporary output ot the treatment timeline using just this modality descriptions with a
# crude renal reg modality code assigned to them - HD PD Transplant vCKD - all other modalities
# fall through the gaps at this stage until we implement this properly. Also sub RR modal codes
# like CAPD and HDF are not yet implemented, just the top level modality.
patient.modalities.each do |modality|
  next if modality.description.ukrdc_modality_code_id.blank?

  xml.Treatment do
    xml.EncounterNumber modality.id
    xml.EncounterType "N"
    xml.FromTime modality.started_on&.iso8601
    xml.ToTime(modality.ended_on&.iso8601) if modality.ended_on.present?

    xml.HealthCareFacility do
      xml.CodingStandard "ODS"
      xml.Code Renalware.config.ukrdc_site_code
    end

    xml.AdmitReason do
      xml.CodingStandard "CF_RR7_TREATMENT"
      xml.Code Renalware::UKRDC::ModalityCode.find(modality.description.ukrdc_modality_code_id).txt_code
    end
  end
end
