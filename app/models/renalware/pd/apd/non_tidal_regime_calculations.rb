require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class NonTidalRegimeCalculations < RegimeCalculations

        def calculated_overnight_volume
          return INCALCULABLE unless volume_calculable?
          fill_volume * cycles
        end

        private

        def volume_calculable?
          fill_volume.to_i > 0 && cycles.to_i > 0
        end
      end
    end
  end
end
