# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    #
    # Responsible for coordinating the processing sequences of a raw HL7 message.
    #
    class MessageProcessor
      include Broadcasting

      # For SubscriptionRegistry only, may not be needed as also inc in Broadcasting module
      include Wisper::Publisher

      def call(raw_message)
        broadcast_args = nil

        # We want to wrap message processing in a transaction because if message processing
        # fails we don't want to leave an unprocessed message in the feed_messages table.
        # If we did, and the same FeedJob retires a few minutes later, if will try to save to
        # feed_messages with the same MD5 body_hash (the message is identical to one already saved)
        # resulting in unique key violation.
        # Using a transaction here prevents any orphaned records if there is an error.
        # However we should be aware that any listeners raising an error will prevent successful
        # in all other listeners. So a listener should be careful to catch errors and not re-raise
        # them, or use the :message_processed message (lower down) which is safer.
        ActiveRecord::Base.transaction do
          hl7_message = build_hl7_object_from(raw_message)
          feed_message = persist_message(hl7_message)
          broadcast_args = { hl7_message: hl7_message, feed_message: feed_message }
          broadcast(:message_arrived, broadcast_args)
        end

        # Another event, this one letting anyone interested know that a message been successfully
        # processed. They might want to forward the message on somewhere else for instance.
        # Think Diaverum.
        # The crucial difference here is that an exception raised by a listener does not prevent the
        # main processing of the HL7 message from being rolled back.
        # They could use this for message processing but we'd rather it was used for post-processing
        # e.g. forwarding, logging etc.
        broadcast(:message_processed, broadcast_args)
      rescue StandardError => exception
        notify_exception(exception)
        raise exception
      end

      private

      def build_hl7_object_from(raw_message)
        MessageParser.new.parse(raw_message)
      end

      # If the incoming message has already been processed we should not be processing it again.
      # To help enforce this there is a unique MD5 hash on feed_messages which will baulk if the
      # same message payload is saved twice - in this case we exit #call early, the broadcast
      # is not issued and therefore the message is not processed. The message will go back into
      # the delayed_job queue and retry, failing until it finally gives up!
      def persist_message(hl7_message)
        PersistMessage.new.call(hl7_message)
      end

      def notify_exception(exception)
        Engine.exception_notifier.notify(exception)
      end
    end
  end
end
