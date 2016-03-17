require_dependency "renalware"

module Renalware
  module Feeds
    module_function

    def table_name_prefix
      "feed_"
    end

    def subscribe_to_message_processor(listener_class)
      message_processor_listeners << listener_class.name
    end

    def message_processor
      @message_processor ||= build_processor
    end

    def build_processor
      MessageProcessorFactory.new(message_processor_listeners).instance
    end

    def message_processor_listeners
      Rails.configuration.x.renalware.message_processor_listeners
    end
  end
end
