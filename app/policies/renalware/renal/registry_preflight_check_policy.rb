require_dependency "renalware/renal"

module Renalware
  module Renal
    class RegistryPreflightCheckPolicy < BasePolicy
      def deaths?
        index?
      end

      def patients?
        index?
      end
    end
  end
end
