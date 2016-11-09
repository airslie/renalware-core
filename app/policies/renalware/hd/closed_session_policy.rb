module Renalware
  module HD
    class ClosedSessionPolicy < BasePolicy
      def destroy?
        edit?
      end

      def edit?
        ! record.immutable?
      end
    end
  end
end
