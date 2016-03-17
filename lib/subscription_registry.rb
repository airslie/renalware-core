require "set"

# Responsible for subscribing listeners to specific classes. This registry
# avoids the issues of global subscriptions which would need to be disabled
# if you wish to use an instance of the class without listeners and avoids
# the issues with Rails auto-loading feature.
#
# This registry is primary used to allow a listener in one module to
# subscribe to broadcasters in a different module allowing the developer to
# manage dependencies in the direction they prefer. Subscriptions within the
# same module should be made directly against the broadcaster, not via
# this registry.
#
# Assumes broadcasters respond to the `subscribe` method.
#
# Usage:
#
# Register the listener class with the broadcaster class.
#
#    SubscriptionRegistry.instance.register(OtherModule::Broadcaster, Listener)
#
# Then in the other module, subscribe to those listeners.
#
#    broadcaster = SubscriptionRegistry.instance.subscribe_listeners_to(Broadcaster.new)
#
class SubscriptionRegistry
  include Singleton

  def register(broadcaster_class, listener_class)
    fetch_key(broadcaster_class.name).add listener_class.name
  end

  def subscribe_listeners_to(broadcaster_instance)
    broadcaster_instance.tap { |processor| subscribe_listeners(broadcaster_instance) }
  end

  private

  def fetch_key(broadcaster_class_name)
    registry[broadcaster_class_name] ||= Set.new
  end

  def subscribe_listeners(broadcaster_instance)
    fetch_key(broadcaster_instance.class.name).each do |listener_class_name|
      broadcaster_instance.subscribe(listener_class_name.constantize.new)
    end
  end

  def registry
    @registry ||= Hash.new
  end
end
