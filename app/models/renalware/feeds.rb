# frozen_string_literal: true

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

    # Note we are using both the SubscriptionRegistry (which we think is not thread safe)
    # as does not store the registry in TLS (?) and also the newer subscription_map
    # We need to consolidate these.
    def build_message_processor
      SubscriptionRegistry
        .instance
        .subscribe_listeners_to(MessageProcessor.new)
        .broadcasting_to_configured_subscribers
    end
  end
end
