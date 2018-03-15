# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module Broadcasting
    include Wisper::Publisher
    extend ActiveSupport::Concern

    # Subscribes any listeners configured in Renalware.config.broadcast_subscription_map
    # to the current instance.
    #
    # Example usage
    #
    #   class SomeServiceObject
    #     include Broadcasting
    #
    #     def call
    #       ..
    #     end
    #   end
    #
    #   SomeServiceObject.new(..).broadcasting_to_configured_subscribers.call(..)
    #
    # See https://github.com/krisleech/wisper
    #
    def broadcasting_to_configured_subscribers
      subscribers = Renalware.config.broadcast_subscription_map[self.class.name]
      Array(subscribers).each{ |listener|
        subscribe(listener.to_s.constantize.new)
      }
      self
    end
  end
end
