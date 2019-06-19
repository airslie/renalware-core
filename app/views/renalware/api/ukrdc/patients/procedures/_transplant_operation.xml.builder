xml = builder

xml.TransplantProcedure do
  xml.ProcedureTime operation.performed_on&.iso8601

  if operation.hospital_centre_code.present?
    xml.EnteredAt do
      xml.CodingStandard "ODS"
      xml.Code operation.hospital_centre_code
      xml.Description operation.hospital_centre_name
    end
  end

  if operation.operation_type.present?
    xml.ProcedureType do
      xml.CodingStandard "SNOMED"
      xml.Code operation.procedure_type_snomed_code
      xml.Description operation.procedure_type_name
    end
  end

  xml.Attributes do
    xml.TRA76
  end
end
