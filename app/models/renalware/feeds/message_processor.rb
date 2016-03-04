require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageProcessor
      def call(raw_message)
        begin
           message_payload = Renalware::Feeds::MessageParser.new.parse(raw_message)
           Renalware::Feeds::MessagePersister.new.call(message_payload)
           params = Renalware::Pathology::MessageParamParser.new.parse(message_payload)
           Renalware::Pathology::CreateObservations.new.call(params)
        rescue Exception => error
          # TODO: Add notifier
          raise error
        end
      end
    end
  end
end
