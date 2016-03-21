require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class PersistMessage
      def call(message_payload)
        Message.create!(
          event_code: message_payload.type,
          header_id: message_payload.header_id,
          body: message_payload.to_s
        )
      end
    end
  end
end
