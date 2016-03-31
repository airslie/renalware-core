require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Responsible for co-ordinating the processing sequences of a raw
    # HL7 message.
    #
    class MessageProcessor
      include Wisper::Publisher

      def call(raw_message)
        message_payload = parse_message(raw_message)
        persist_message(message_payload)

        broadcast(:message_processed, message_payload)
      rescue StandardError => exception
        notify_exception(exception)
        raise exception
      end

      private

      def parse_message(raw_message)
        MessageParser.new.parse(raw_message)
      end

      def persist_message(message_payload)
        PersistMessage.new.call(message_payload)
      end

      def notify_exception(exception)
        ExceptionNotifier.new.notify(exception)
      end
    end
  end
end
