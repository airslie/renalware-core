require_dependency "renalware/pd"

module Renalware
  module PD
    class BagVolume

      def self.values
        1000.step(5000, 250).to_a
      end
    end
  end
end
