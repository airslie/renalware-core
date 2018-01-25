require_dependency "renalware/events"

# This controller is mostly empty - we are using it for mainly routing and to let us
# override the events 'new' and 'edit' templates. See the base class for most functionality.
module Renalware
  module Events
    class InvestigationsController < EventsController
    end
  end
end
