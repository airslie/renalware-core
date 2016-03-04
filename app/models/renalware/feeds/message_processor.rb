require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageProcessor
      def call(raw_message)
        begin
           message_payload = MessageParser.new.parse(raw_message)
           MessagePersister.new.call(message_payload)
           params = Pathology::MessageParamParser.new.parse(message_payload)
           Pathology::CreateObservations.new.call(params)
        rescue Exception => error
          # TODO: Add notifier
          raise error
        end
      end
    end
  end
end
