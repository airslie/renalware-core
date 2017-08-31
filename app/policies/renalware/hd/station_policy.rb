module Renalware
  module HD
    class StationPolicy < BasePolicy
      def sort?
        edit?
      end
    end
  end
end
