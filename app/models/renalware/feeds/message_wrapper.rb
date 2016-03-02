require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageWrapper < SimpleDelegator
      def initialize(message_string)
        @message_string = message_string

        super(::HL7::Message.new(message_string.lines))
      end

      def type
        self[:MSH].message_type
      end

      def to_s
        @message_string
      end
    end
  end
end
