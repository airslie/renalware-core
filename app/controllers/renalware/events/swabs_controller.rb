require_dependency "renalware/events"

# This controller is empty - we are just using it for routing and to let us
# override the events 'new' template. If you need to add any other hard-wired
# event types, its probably best to use the same approach.
module Renalware
  module Events
    class SwabsController < EventsController
    end
  end
end
