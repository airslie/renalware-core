xml = builder

xml.ResultItem do
  xml.ResultType "AT???"
  xml.EnteredOn observation.updated_at&.iso8601
  xml.ObservationTime observation.observed_at&.iso8601
  xml.PrePost "?"
  xml.ServiceId "?"
  xml.SubId "?"
  xml.ResultValue observation.result
  xml.ResultValueUnits "?"
  xml.ReferenceRange "?"
end
