require_dependency "renalware/events"

module Renalware
  module Events
    class SwabPolicy < EventPolicy
      def edit?
        true
      end
      alias_method :update?, :edit?
    end
  end
end
