xml = builder

xml.Transplant do
  if operation.operation_type.present?
    xml.ProcedureType do
      xml.CodingStandard "SNOMED"
      xml.Code operation.procedure_type_snomed_code
      xml.Description operation.procedure_type_name
    end
  end

  xml.ProcedureTime operation.performed_on&.to_time&.iso8601

  if operation.hospital_centre_code.present?
    xml.EnteredAt do
      xml.CodingStandard "ODS"
      xml.Code operation.hospital_centre_code
      xml.Description operation.hospital_centre_name
    end
  end

  xml.Attributes do
    if operation.nhsbt_type.present?
      xml.TRA77 operation.nhsbt_type
    end
    # Note sending TRA76 yet as defined as datetime in XSD and needs changeing there.
    # if operation.rr_tra76_options.present?
    #   xml.TRA76 do
    #     xml.CodingStandard "CF_RR7_TREATMENT"
    #     xml.Code operation.rr_tra76_options[:code]
    #     xml.Description operation.rr_tra76_options[:description]
    #   end
    # end
  end
end
