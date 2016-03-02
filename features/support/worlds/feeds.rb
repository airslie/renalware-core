module World
  module Feeds
    module Domain
      def parse_message(raw_message)
        Renalware::Feeds::MessageParser.new.parse(raw_message)
      end

      def process_message(message_payload)
       Renalware::Feeds::MessagePersister.new.call(message_payload)
       command = Renalware::Pathology::MessageCommandParser.new.parse(message_payload)
      end

      def expect_message_to_be_recorded(message)
        message_record = Renalware::Feeds::Message.find_by(event_code: message.type)
        expect(message_record).to be_present
      end
    end
  end
end
