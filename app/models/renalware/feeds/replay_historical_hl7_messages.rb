# frozen_string_literal: true

# 'patient_added' event...
#   -> Renalware::Feeds::PatientListener receives the event
#     -> ReplayHistoricalHL7MessagesJob.perform_later(patient) # async so main thread not held up
#       -> ReplayHistoricalHL7Messages.call(patient: patient) # does the heavy lifting
#         -> for each replayable path message fetched via ReplayableHL7PathologyMessagesQuery
#           -> broadcast oru_message_arrived event
#             -> Renalware::Patients::Ingestion::MessageListener
#             -> Renalware::Pathology::Ingestion::AKIListener
#             -> Renalware::Pathology::Ingestion::MessageListener
#             -> Renalware::Clinics::Ingestion::MessageListener
#             -> Renalware::Pathology::KFRE::Listener
#             -> ... extensible list
module Renalware
  module Feeds
    class ReplayHistoricalHL7MessagesJob
      include Broadcasting
      pattr_initialize [:patient!]

      BATCH_SIZE = 200

      def self.call(...)
        new(...)
          .broadcasting_to_configured_subscribers
          .call
      end

      def call
        query = ReplayableHL7MessagesQuery.call(patient: patient)
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
