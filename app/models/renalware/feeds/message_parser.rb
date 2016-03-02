require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageParser
      def self.parse(raw_message)
        new.parse(raw_message)
      end

      def parse(raw_message)
        Message.new
      end
    end
  end
end
