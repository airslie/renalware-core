# frozen_string_literal: true

xml = builder

# TODO: Implement start stop dates
xml.LabOrders(
  start: patient.changes_since.to_date.iso8601,
  stop: patient.changes_up_until.to_date.iso8601
) do
  patient.observation_requests.each do |request|
    xml.LabOrder do
      xml.PlacerId request.placer_id
      xml.OrderCategory do
        xml.Code request.description.code
      end
      xml.SpecimenCollectedTime request.requested_at&.iso8601
      xml.SpecimenSource request.description.bottle_type
      xml.ResultItems do
        request.observations.each do |observation|
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
        end
      end
      xml.EnteredOn request.requested_at.iso8601
    end
  end
end
