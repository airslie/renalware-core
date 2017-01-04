require_dependency "renalware/pd"
require_dependency "renalware/pd/apd/glucose_calculator"

module Renalware
  module PD
    module APD
      class CalculateVolumes

        def initialize(regime)
          raise ArgumentError("Not an APD regime") unless regime.apd?
          @regime = decorate(regime)
        end

        # rubocop:disable Metrics/AbcSize
        def call
          regime.overnight_volume = regime.calculated_overnight_volume
          regime.daily_volume = regime.calculated_daily_volume
          regime.glucose_volume_percent_1_36 = regime.volume_of_glucose_at(percent: 1.36)
          regime.glucose_volume_percent_2_27 = regime.volume_of_glucose_at(percent: 2.27)
          regime.glucose_volume_percent_3_86 = regime.volume_of_glucose_at(percent: 3.86)
        end
        # rubocop:enable Metrics/AbcSize

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
