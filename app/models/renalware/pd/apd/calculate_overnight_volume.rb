require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class CalculateOvernightVolume

        def initialize(regime)
          raise ArgumentError("Not an APD regime") unless regime.apd?
          @regime = regime
        end

        def call
          regime.overnight_pd_volume = decorate(@regime).overnight_volume
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
