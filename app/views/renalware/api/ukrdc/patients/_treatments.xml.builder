# frozen_string_literal: true

xml = builder

# A temporary output of the treatment timeline using just modality descriptions with a
# crude renal reg modality code assigned to them - HD, PD, Transplant, vCKD - all other modalities
# fall through the gaps at this stage until we implement this properly. Also sub RR modal codes
# like CAPD and HDF are not yet implemented, just the top level modality.
patient.modalities.each do |modality|
  ukrdc_modality_code_id = modality.description.ukrdc_modality_code_id
  next if ukrdc_modality_code_id.blank?

  ukrdc_modality_code = Renalware::UKRDC::ModalityCode.find(ukrdc_modality_code_id)

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
      xml.Code ukrdc_modality_code.txt_code
    end

    # # This is a bit of hack to get the HD Profile location for the current modality
    # if [1, 2, 3, 4, 5, 9].include?(ukrdc_modality_code.txt_code.to_i) # HD
    #   profile = Renalware::HD::Profile
    #     .for_patient(patient)
    #     .where(<<-SQL).first
    #     created_at::date <= '#{modality.started_on}'
    #     and (
    #       deactivated_at is NULL or
    #       (
    #         deactivated_at >= '#{modality.started_on}'
    #       )
    #     )
    #     SQL
    #   if profile&.hospital_unit.present?
    #     xml.Attributes do
    #       xml.QBL05 profile.hospital_unit.unit_type # eg home
    #     end
    #   end
    # end
  end
end
