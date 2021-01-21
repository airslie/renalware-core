# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class EventPolicy < BasePolicy
      # The default Event is not editable. See SwabPolicy for an example of enabling editing.
      def edit?
        false
      end
      alias update? edit?

      def destroy?
        false
      end
    end
  end
end
