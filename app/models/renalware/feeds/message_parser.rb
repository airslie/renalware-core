require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageParser
      def parse(message_string)
        HL7Message.new(message_string)
      end
    end
  end
end
