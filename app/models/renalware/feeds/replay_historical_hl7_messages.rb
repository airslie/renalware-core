# frozen_string_literal: true

module Renalware
  module Feeds
    class ReplayHistoricalHL7Messages
      include Callable
      pattr_initialize :patient, :message_types

      BATCH_SIZE = 200

      def call
        query = ReplayableHL7MessagesQuery.call(patient: patient, message_types: message_types)
        query.find_in_batches(batch_size: BATCH_SIZE) do |batch|
          batch.each do |feed_message|
            Rails.logger.debug(feed_message) # TODO: replay message
          end
        end
      end
    end
  end
end
