require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Responsible for parsing a raw HL7 message as a string and creates a
    # message object.
    #
    class MessageParser
      def parse(message_string)
        HL7Message.new(message_string)
      end
    end
  end
end
