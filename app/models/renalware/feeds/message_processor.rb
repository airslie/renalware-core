# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    #
    # Responsible for coordinating the processing sequences of a raw HL7 message.
    #
    class MessageProcessor
      include Wisper::Publisher

      def call(raw_message)
        ActiveRecord::Base.transaction do
          message_payload = parse_message(raw_message)
          persist_message(message_payload)
          broadcast(:message_processed, message_payload)
        end
      rescue StandardError => exception
        notify_exception(exception)
        raise exception
      end

      private

      def parse_message(raw_message)
        MessageParser.new.parse(raw_message)
      end

      # If the incoming message has already been processed we should not be processing it again.
      # To help enforce this there is a unique MD5 hash on feed_messages which will baulk if the
      # same message payload is saved twice - in this case we exit #call early, the broadcast
      # is not issued and therefore the message is not processed. The message will go back into
      # the delayed_job queue and retry, failing until it finally gives up!
      def persist_message(message_payload)
        PersistMessage.new.call(message_payload)
      end

      def notify_exception(exception)
        Engine.exception_notifier.notify(exception)
      end
    end
  end
end
