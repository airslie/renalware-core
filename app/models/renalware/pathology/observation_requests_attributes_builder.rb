# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    # Responsible for transforming an HL7 message payload into a params hash
    # that can be persisted by ObservationRequest.
    # Note:
    # - A message can have multiple observation_requests, each with its own observations.
    # - We create any missing *_description or measurement_unit rows - ie if a new OBR 'ABC' arrives
    # - from the lab and we have not seen it before, we create a corresponding
    # - observation_request_description first. Likewise for previously unseen OBX codes we will
    # - create a new observation_description in realtime. If a OBC has a unit we have not seen
    #   before eg MW (Megawatts!) we create that also. In this way the pathology 'metadata' is
    #   keep up to date based on what the lab/send.
    #
    # Note this class could be removed and a Builder class used to create the database models
    # directly - this would remove the extra level of indirection that this class introduces.
    class ObservationRequestsAttributesBuilder
      DEFAULT_REQUESTOR_NAME = "UNKNOWN"
      delegate :patient_identification, :observation_requests, to: :hl7_message
      delegate :internal_id, to: :patient_identification
      alias_attribute :requests, :observation_requests

      # hl7_message is an HL7Message (a decorator around an ::HL7::Message)
      def initialize(hl7_message, logger = Delayed::Worker.logger)
        @hl7_message = hl7_message
        @sender = find_or_create_sender
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
        patient.present?
        # Patient.exists?(local_patient_id: internal_id)
      end

      private

      attr_reader :hl7_message, :logger, :sender

      def find_or_create_sender
        Sender.resolve!(
          sending_facility: hl7_message.sending_facility,
          sending_application: hl7_message.sending_app
        )
      end

      def build_patient_params
        # patient = find_patient(internal_id)
        request_params.each do |request_param|
          request_param[:patient_id] = patient&.id
        end
      end

      def request_params
        @request_params ||= build_observation_request_params
      end

      # Returns an array of hashes each containing an observation_request entry
      # that wil be used to create associated database rows
      # e.g. [ { observation_request: {..} }, {...} ]
      #
      # rubocop:disable Metrics/MethodLength
      def build_observation_request_params
        requests.each_with_object([]) do |request, arr|
          request_description = find_request_description(
            code: request.identifier,
            name: request.name
          )
          hash = {
            observation_request: {
              description_id: request_description.id,
              requestor_name: request.ordering_provider_name || DEFAULT_REQUESTOR_NAME,
              requestor_order_number: request.placer_order_number,
              filler_order_number: request.filler_order_number,
              requested_at: parse_time(request.date_time),
              observations_attributes: build_observations_params(request)
            }
          }
          arr << hash
        end
      end
      # rubocop:enable Metrics/MethodLength

      # Returns an array of hashes where each has the attributes used to create a new
      # pathology_observation in the datbase when passed inside the observation_request hash]
      # built in build_observation_request_params { observations_attributes: [..] }
      # rubocop:disable Metrics/MethodLength, Performance/MapCompact
      def build_observations_params(request)
        request.observations.map do |observation|
          observation_description = FindOrCreateObservationDescription.new(
            observation: observation,
            sender: sender
          ).call
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
      # rubocop:enable Metrics/MethodLength, Performance/MapCompact

      def find_request_description(code:, name:)
        RequestDescription.find_or_create_by!(code: code) do |desc|
          desc.name = name || code
          desc.lab = Lab.unknown
        end
      rescue ActiveRecord::RecordNotFound
        raise MissingRequestDescriptionError, code
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

      def patient
        @patient ||= Feeds::PatientLocator.call(hl7_message.patient_identification)
      end

      # Default to using today's date and time if no date_time passed in the message
      def parse_time(string)
        return Time.zone.now.to_s if string.blank?

        Time.zone.parse(string).to_s
      end
    end
  end
end
