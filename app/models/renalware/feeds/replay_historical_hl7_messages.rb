# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayHistoricalHL7Messages
      include Broadcasting
      pattr_initialize [:patient!, :message_types!]

      BATCH_SIZE = 200

      def self.call(...)
        new(...)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        query = ReplayableHL7MessagesQuery.call(patient: patient, message_types: message_types)
        query.find_in_batches(batch_size: BATCH_SIZE) do |batch|
          batch.each do |feed_message|
            Rails.logger.debug(feed_message) # TODO: replay message
            allow_listeners_to_process_the_message(feed_message)
            feed_message.update!(processed: true)
          end
        end
      end

      def allow_listeners_to_process_the_message(feed_message)
        hl7_message = MessageParser.parse(feed_message.body)
        message_to_broadcast = "#{hl7_message.message_type.downcase}_message_arrived"
        broadcast(
          message_to_broadcast.to_sym,
          hl7_message: hl7_message,
          feed_message: feed_message
        )
      end
    end
  end
end
