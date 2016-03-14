require_dependency "renalware/feeds"

module Renalware
  module Feeds
    class MessageProcessor
      def call(raw_message)
        begin
           message_payload = parse_message(raw_message)
           persist_message(message_payload)

           params = parse_pathology_params(message_payload)
           create_observations(params)

        rescue Exception => error
          notify_exception(error)
          raise error
        end

        private

        def parse_message(raw_message)
          MessageParser.new.parse(raw_message)
        end

        def persist_message(message_payload)
          MessagePersister.new.call(message_payload)
        end

        def parse_pathology_params(message_payload)
          Pathology::MessageParamParser.new.parse(message_payload)
        end

        def create_observations(params)
          Pathology::CreateObservations.new.call(params)
        end

        def notify_exception(error)
          # TODO: Add notifier
        end
      end
    end
  end
end
