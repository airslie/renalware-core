require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class MessageCommandParser
      Command = Struct.new(:requester_name)

      def parse(message_payload)
        Command.new(
          message_payload.observation_request.ordering_provider
        )
      end
    end
  end
end
