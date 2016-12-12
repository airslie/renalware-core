require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class CalculateVolumes

        def initialize(regime)
          raise ArgumentError("Not an APD regime") unless regime.apd?
          @regime = decorate(regime)
        end

        def call
          regime.overnight_volume = regime.calculated_overnight_volume
          regime.daily_volume = regime.calculated_daily_volume
        end

        private

        attr_reader :regime

        def decorate(regime)
          klass = regime.tidal? ? TidalRegimeCalculations : NonTidalRegimeCalculations
          klass.new(regime)
        end
      end
    end
  end
end
