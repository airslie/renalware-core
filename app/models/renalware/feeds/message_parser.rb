require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageParser
      def self.parse(raw_message)
        new.parse(raw_message)
      end

      def parse(message_string)
        MessageWrapper.new(message_string)
      end
    end
  end
end
