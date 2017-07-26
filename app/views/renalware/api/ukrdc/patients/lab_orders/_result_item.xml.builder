xml = builder
observation = Renalware::Pathology::ObservationPresenter.new(observation)

xml.ResultItem do
  xml.ResultType observation.description_name
  xml.EnteredOn observation.updated_at&.iso8601
  xml.ObservationTime observation.observed_at&.iso8601
  xml.PrePost "?"
  xml.ServiceId "?"
  xml.SubId "?"
  xml.ResultValue observation.result
  xml.ResultValueUnits observation.measurement_unit_name
  xml.ReferenceRange "?"
end
