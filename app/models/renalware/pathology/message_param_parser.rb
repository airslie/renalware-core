require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageParamParser
      def parse(message_payload)
        request = message_payload.observation_request

        observations_params = build_observations_params(request.observations)
        request_params = build_observation_request_params(request, observations_params)
        build_patient_params(message_payload.patient_identification, request_params)
      end

      private

      def build_observation_request_params(request, observations_params)
        request_description = find_request_description(request.identifier)

        {
          observation_request: {
            description_id: request_description.id,
            requestor_name: request.ordering_provider,
            pcs_code: request.placer_order_number,
            observed_at: parse_time(request.date_time),
            observations_attributes: observations_params
          }
        }
      end

      def build_observations_params(observations)
        observations.map do |observation|
          observation_description = find_observation_description(observation.identifier)

          {
            description_id: observation_description.id,
            observed_at: parse_time(observation.date_time),
            result: observation.value,
            comment: observation.comment
          }
        end
      end

      def build_patient_params(patient_identification, params)
        params.tap do |p|
          patient = find_patient(patient_identification.internal_id)
          p[:patient_id] = patient.id
        end
      end

      def find_request_description(code)
        RequestDescription.find_by!(code: code)
      end

      def find_observation_description(code)
        ObservationDescription.find_by!(code: code)
      end

      def find_patient(local_patient_id)
        Patient.find_by!(local_patient_id: local_patient_id)
      end

      def parse_time(string)
        Time.zone.parse(string).to_s
      end
    end
  end
end
