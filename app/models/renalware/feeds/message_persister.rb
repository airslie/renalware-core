require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessagePersister
      def call(message_payload)
        Message.create!(event_code: message_payload.type, body: message_payload.to_s)
      end
    end
  end
end
