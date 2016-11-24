require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class NonTidalRegimeCalculations < SimpleDelegator
        INCALCULABLE = nil

        def overnight_volume
          return INCALCULABLE unless overnight_volume_calculable?

          fill_volume * cycles
        end

        private

        def overnight_volume_calculable?
          fill_volume.to_i > 0 && cycles.to_i > 0
        end
      end
    end
  end
end
