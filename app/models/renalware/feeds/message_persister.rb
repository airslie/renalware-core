require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessagePersister
      def self.call(message_payload)
        new.call(message_payload)
      end

      def self.call(message_payload)
        Message.create!(event_code: message_payload.type, body: message_payload.to_s)
      end
    end
  end
end
