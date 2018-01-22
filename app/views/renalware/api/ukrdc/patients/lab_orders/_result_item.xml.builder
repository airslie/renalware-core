xml = builder
observation = Renalware::Pathology::ObservationPresenter.new(observation)
observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)

xml.ResultItem do
  # xml.ResultType
  xml.EnteredOn observation.updated_at&.iso8601
  xml.PrePost observation.pre_post(patient_is_on_hd: patient.current_modality_hd?)
  xml.ServiceId do
    xml.CodingStandard "LOCAL"
    xml.Code observation.description_code
    xml.Description observation.description_name
  end
  # xml.SubId
  xml.ResultValue observation.result
  xml.ResultValueUnits observation.measurement_unit_name
  # xml.AbnormalFlags
  # xml.Status
  xml.ObservationTime observation.observed_at&.iso8601
  # xml.Comments
  # xml.ReferenceComment
end
