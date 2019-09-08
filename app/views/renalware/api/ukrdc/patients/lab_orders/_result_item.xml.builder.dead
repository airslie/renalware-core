# frozen_string_literal: true

xml = builder
observation = Renalware::Pathology::ObservationPresenter.new(observation)
observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)

xml.ResultItem do
  xml.EnteredOn observation.updated_at&.iso8601
  xml.PrePost observation.pre_post(patient_is_on_hd: patient.current_modality_hd?)
  xml.ServiceId do
    xml.CodingStandard observation.coding_standard
    xml.Code observation.code
    xml.Description observation.description_name
  end

  # If the rrr_type of the observation_descriptions is interpretation (ie an interpretted result
  # like POS NEG)
  if observation.rr_type_interpretation?
    xml.InterpretationCodes observation.interpretation_code
  else
    xml.ResultValue observation.result
    xml.ResultValueUnits observation.measurement_unit_name
  end

  xml.ObservationTime observation.observed_at&.iso8601
end
