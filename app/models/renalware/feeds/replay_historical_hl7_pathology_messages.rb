# frozen_string_literal: true

# 'patient_added' event...
#   -> Renalware::Feeds::PatientListener receives the event
#     -> ReplayHistoricalHL7PathologyMessagesJob.perform_later(patient) # async
#       -> ReplayHistoricalHL7PathologyMessages.call(patient: patient) # does the heavy lifting
#         -> for each replayable path message fetched via ReplayableHL7PathologyMessagesQuery
#           -> broadcast oru_message_arrived event
#             -> Renalware::Pathology::Ingestion::MessageListener
#             -> ... extensible list
module Renalware
  module Feeds
    class ReplayHistoricalHL7PathologyMessages
      include Broadcasting
      pattr_initialize [:patient!, reason: ""]

      BATCH_SIZE = 200

      def self.call(...)
        new(...)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        query = ReplayableHL7PathologyMessagesQuery.call(patient: patient)
        ReplayRequest.start_logging(patient, reason) do |replay_request|
          query.find_in_batches(batch_size: BATCH_SIZE) do |batch|
            batch.each do |feed_message|
              replay_request.log(feed_message) do
                allow_listeners_to_process_the_message(feed_message)
              end
            end
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
