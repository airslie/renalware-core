require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class Message < ActiveRecord::Base
      validates :event_code, presence: true
      validates :body, presence: true

      def self.for(message_payload)
        new(event_code: message_payload.type, body: message_payload.to_s)
      end

      def to_s
        @body
      end
    end
  end
end
