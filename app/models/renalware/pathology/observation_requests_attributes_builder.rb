# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for transforming an HL7 message payload into a params hash
    # that can be persisted by ObservationRequest.
    # Note:
    # - A message can have multiple observation_requests, each with its own observations.
    # - This class could be removed and a Builder class used to create the database models
    # directly - this would remove the extra level of indirection that this class introduces.
    class ObservationRequestsAttributesBuilder
      delegate :patient_identification, :observation_requests, to: :message_payload
      delegate :internal_id, to: :patient_identification
      alias_attribute :requests, :observation_requests

      # message_payload is an HL7Message (a decorator around an ::HL7::Message)
      def initialize(message_payload, logger = Delayed::Worker.logger)
        @message_payload = message_payload
        @logger = logger
      end

      # Return an array of observation request attributes (with a nested array of
      # child observation attributes) for each OBR in the HL7 message.
      # The resulting array will be used to create the corresponding database records.
      def parse
        if renalware_patient?
          build_patient_params
        else
          logger.debug("Did not process pathology for #{internal_id}: not a renalware patient")
          nil
        end
      end

      def renalware_patient?
        Patient.exists?(local_patient_id: internal_id)
      end

      private

      attr_reader :message_payload, :logger

      def build_patient_params
        patient = find_patient(internal_id)
        request_params.each do |request_param|
          request_param[:patient_id] = patient.id
        end
      end

      def request_params
        @request_params ||= build_observation_request_params
      end

      # rubocop:disable Metrics/MethodLength
      def build_observation_request_params
        requests.each_with_object([]) do |request, arr|
          request_description = find_request_description(request.identifier)
          hash = {
            observation_request: {
              description_id: request_description.id,
              requestor_name: request.ordering_provider_name,
              requestor_order_number: request.placer_order_number,
              requested_at: parse_time(request.date_time),
              observations_attributes: build_observations_params(request)
            }
          }
          arr << hash
        end
      end
      # rubocop:enable Metrics/MethodLength

      def build_observations_params(request)
        request.observations.map do |observation|
          observation_description = find_observation_description(observation.identifier)
          next unless validate_observation(observation, observation_description)
          {
            description_id: observation_description.id,
            observed_at: parse_time(observation.date_time),
            result: observation.value,
            comment: observation.comment,
            cancelled: observation.cancelled
          }
        end.compact
      end

      def find_request_description(code)
        RequestDescription.find_by!(code: code)
      end

      def find_observation_description(code)
        ObservationDescription.find_by!(code: code)
      end

      def validate_observation(observation, observation_description)
        if observation.date_time.blank?
          logger.warn(
            "Skipped observation with blank `observed_at` (date_time) "\
            "in OBX with code #{observation_description.code}"
          )
          false
        else
          true
        end
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
