xml = builder

xml.Observations do
  # TODO: Loop through observations
  xml.Observation do
    xml.ObservationTime

    xml.ObservationCode do
      xml.CodingStandard
      xml.Code
      xml.Description
    end

    xml.ObservationValue
    xml.ObservationUnits
    xml.Comments

    xml.Clinician do
      xml.CodingStandard
      xml.Code
      xml.Description
    end
  end
end
