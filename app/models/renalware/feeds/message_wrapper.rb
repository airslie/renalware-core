require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # ObservationResultMessage
    class MessageWrapper < SimpleDelegator
      def initialize(message_string)
        @message_string = message_string
        @message = ::HL7::Message.new(message_string.lines)

        super(@message)
      end

      class ObservationRequest < SimpleDelegator
        def ordering_provider
          self[:OBR].ordering_provider
        end
      end

      def observation_request
        ObservationRequest.new(@message)
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
