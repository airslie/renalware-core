require_dependency "renalware"
require "subscription_registry"

module Renalware
  module Feeds
    module_function

    def table_name_prefix
      "feed_"
    end

    def message_processor
      @message_processor ||= build_message_processor
    end

    def build_message_processor
      SubscriptionRegistry
        .instance
        .subscribe_listeners_to(MessageProcessor.new)
    end
  end
end
