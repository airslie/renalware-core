# frozen_string_literal: true

require_dependency "renalware/events"
require_dependency "renalware/low_clearance"

# This controller is mostly empty as we inherit from EventsController (see that for functionality).
# It exists to preserve domain separation within routes.rb and to keep things clean.
# a bit cleaner.
module Renalware
  module LowClearance
    class AdvancedCarePlansController < Events::EventsController
    end
  end
end
