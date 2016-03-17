require_dependency "renalware/feeds"

module Renalware
  module Feeds
    # Responsible for creating a MessageProcessor and subscribing it's listeners
    #
    class MessageProcessorFactory
      def initialize(listener_class_names)
        @listener_class_names = listener_class_names
      end

      def instance
        MessageProcessor.new.tap { |processor| subscribe_listeners(processor) }
      end

      private

      def subscribe_listeners(processor)
        @listener_class_names.each do |listener_class_name|
          processor.subscribe(listener_class_name.constantize.new)
        end
      end
    end
  end
end
