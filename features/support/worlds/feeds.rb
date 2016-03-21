module World
  module Feeds
    module Domain
      def parse_message(raw_message)
        Renalware::Feeds::MessageParser.new.parse(raw_message)
      end

      def process_message(raw_message)
        Renalware::Feeds.message_processor.call(raw_message)
      end

      def expect_message_to_be_recorded(message)
        message_record = Renalware::Feeds::Message.find_by(event_code: message.type)
        expect(message_record).to be_present
      end
    end
  end
end
