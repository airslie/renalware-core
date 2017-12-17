require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for transforming an HL7 message payload into a params hash
    # that can be persisted by ObservationRequest.
    #
    class MessageParamParser
      attr_reader :message_payload
      delegate :patient_identification, :observation_request, to: :message_payload
      delegate :internal_id, to: :patient_identification
      delegate :observations, to: :observation_request
      alias_attribute :request, :observation_request

      # message_payload is an HL7Message (a decorator around an ::HL7::Message)
      def initialize(message_payload)
        @message_payload = message_payload
      end

      def parse
        if renalware_patient?
          build_patient_params
        else
          Rails.logger.warn(
            "Did not process pathology for #{internal_id}: not a renalware patient"
          )
          nil
        end
      end

      def renalware_patient?
        Patient.exists?(local_patient_id: internal_id)
      end

      private

      def observations_params
        @observations_params ||= build_observations_params
      end

      def request_params
        @request_params ||= build_observation_request_params
      end

      def build_observation_request_params
        request_description = find_request_description(request.identifier)

        {
          observation_request: {
            description_id: request_description.id,
            requestor_name: request.ordering_provider_name,
            requestor_order_number: request.placer_order_number,
            requested_at: parse_time(request.date_time),
            observations_attributes: observations_params
          }
        }
      end

      def build_observations_params
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

      def build_patient_params
        request_params.tap do |p|
          patient = find_patient(internal_id)
          p[:patient_id] = patient.id
        end
      end

      def find_request_description(code)
        RequestDescription.find_by!(code: code)
      end

      def find_observation_description(code)
        ObservationDescription.find_by!(code: code)
      end

      # TODO: Support searching by other local patient ids?
      def find_patient(local_patient_id)
        Patient.find_by!(local_patient_id: local_patient_id)
      end

      def parse_time(string)
        Time.zone.parse(string).to_s
      end
    end
  end
end
