xml = builder
observation = Renalware::Pathology::ObservationPresenter.new(observation)
observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)

xml.ResultItem do
  xml.EnteredOn observation.updated_at&.iso8601
  xml.ObservationTime observation.observed_at&.iso8601
  xml.PrePost observation.pre_post(patient.current_modality_hd?)
  xml.ResultValue observation.result
  xml.ResultValueUnits observation.measurement_unit_name
  xml.ServiceId do
    xml.Code observation.description_code
    xml.CodingStandard "LOCAL"
    xml.Description observation.description_name
  end
end
