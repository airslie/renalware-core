# frozen_string_literal: true

require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class PersistMessage
      # message_payload is an HL7Message (a decorator around ::HL7::Message)
      # If the same message is persisted twice we'll get an ActiveRecord::RecordNotUnique error
      # but that's fine as we don't want to process the same HL7 message twice.
      def call(message_payload)
        Message.create!(
          event_code: message_payload.type,
          header_id: message_payload.header_id,
          body: message_payload.to_s,
          body_hash: Digest::MD5.hexdigest(message_payload.to_s)
        )
      end
    end
  end
end
