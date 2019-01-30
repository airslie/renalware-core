# frozen_string_literal: true

xml = builder
observation = Renalware::Pathology::ObservationPresenter.new(observation)
observation = Renalware::UKRDC::PathologyObservationPresenter.new(observation)
result = observation.result || ""

# The UKRDC XSD Schema specifies that observations cannot be longer than 20 characters.
# KCH regularly get notes in the result, saying things like "No recent Urea result" - which in this
# case exceeds 20 characters. We need to skip these.
if result.length <= 20
  xml.ResultItem do
    xml.EnteredOn observation.updated_at&.iso8601
    xml.PrePost observation.pre_post(patient_is_on_hd: patient.current_modality_hd?)
    xml.ServiceId do
      if observation.description_loinc_code.present?
        xml.CodingStandard "PV"
        xml.Code observation.description_loinc_code
      else
        xml.CodingStandard "LOCAL"
        xml.Code observation.description_code
      end
      xml.Description observation.description_name
    end
    xml.ResultValue observation.result
    xml.ResultValueUnits observation.measurement_unit_name
    xml.ObservationTime observation.observed_at&.iso8601
  end
end
