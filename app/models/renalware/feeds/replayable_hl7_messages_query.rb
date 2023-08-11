# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayableHL7MessagesQuery
      pattr_initialize :patient, :message_types

      BATCH_SIZE = 200
      PATIENT_IDENTIFICATION_COLUMNS = %i(
        nhs_number
        local_patient_id
        local_patient_id_2
        local_patient_id_3
        local_patient_id_4
        local_patient_id_5
      ).freeze

      def self.call(patient, message_types)
        message_types = ensure_message_types_are_lowercase_symbols(message_types)
        raise(ArgumentError, "No message_types specified") if message_types.empty?

        new(patient, message_types).call
      end

      def call
        scope = feed_messages_scoped_by_message_type
          .merge(feed_messages_scoped_by_patient)
          .order(created_at: :asc)
        # puts scope.to_sql
        # scope.all #find_in_batches(batch_size: BATCH_SIZE)
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
          .where(message_type: "ORU")
          .where(event_type: "R01")
      end

      def ensure_message_types_are_lowercase_symbols(message_types)
        Array(message_types).map { |mt| mt.to_s.downcase.to_sym }
      end
    end
  end
end
