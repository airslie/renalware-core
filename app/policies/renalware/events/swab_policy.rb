# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class SwabPolicy < EventPolicy
      def edit?
        true
      end
      alias update? edit?
    end
  end
end
