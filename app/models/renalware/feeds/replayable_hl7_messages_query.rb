# frozen_string_literal: true

module Renalware
  module Feeds
    # When a new patient is added to Renalware, its possible and likely we will have received
    # HL7 messages for them at some point in the past given that we store all ADT (demographics)
    # and ORU (pathology) messages for all patients in the hospital, routed via our Mirth server.
    # So it would be nice to replay a patient's historical messages, but this time, instead of
    # ignoring their content becuase the patient is not in Renalware, they will be imported and
    # associated with the patient.
    #
    # This query object finds feed_messages that
    # - relate to the supplied patient
    # - have not been imported yet
    # and replays them.
    # We can in theory replay ADT or ORU messages but currently do only ORU (pathology) becuase it
    # it is deemed that ince the patient is added to Renalware, subsequent ADT HL7 messages which
    # will soon arrive will being the demographic data up to date - so no point replaying ADT
    # messages really, and might in fact lead to confusion.
    class ReplayableHL7MessagesQuery
      include Callable
      attr_reader :patient, :message_types

      class MissingMessageTypesError < StandardError; end
      class InvalidMessageTypesError < StandardError; end

      MESSAGE_TYPES = %i(ORU ADT).freeze
      PATIENT_IDENTIFICATION_COLUMNS = %i(
        nhs_number
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).freeze

      def initialize(patient:, message_types:)
        @patient = patient
        @message_types = Array(message_types)
      end

      def call
        validate_message_types

        feed_messages_scoped_by_message_type
          .merge(feed_messages_scoped_by_patient)
          .order(created_at: :asc)
      end

      private

      def feed_messages_scoped_by_patient
        scope = Renalware::Feeds::Message.none
        PATIENT_IDENTIFICATION_COLUMNS.each do |col|
          if patient.public_send(col).present?
            scope = scope.or(Message.where(col => patient.public_send(col)))
          end
        end
        scope
      end

      # For now assume ORU R01
      def feed_messages_scoped_by_message_type
        Renalware::Feeds::Message
          .where(message_type: "ORU", event_type: "R01") # NOTE: not honouring message_types here
          .where.not(processed: true)
      end

      def validate_message_types
        raise(MissingMessageTypesError) if message_types.empty?

        unrecognised_message_types = message_types - MESSAGE_TYPES
        if unrecognised_message_types.any?
          raise InvalidMessageTypesError, unrecognised_message_types.to_s
        end
      end
    end
  end
end
