# frozen_string_literal: true

require_dependency "renalware/events"

module Renalware
  module Events
    class InvestigationPolicy < EventPolicy
      def edit?
        true
      end
      alias update? edit?
    end
  end
end
