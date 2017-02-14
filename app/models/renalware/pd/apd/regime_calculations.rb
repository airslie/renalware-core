require_dependency "renalware/pd"
require_relative "./glucose_calculator"

module Renalware
  module PD
    module APD
      class RegimeCalculations < SimpleDelegator
        INCALCULABLE = nil

        def calculated_overnight_volume
          raise NotImplementedAError
        end

        #  The total volume of all bags for a day when they have PD.
        def calculated_daily_volume
          vol = [
            calculated_overnight_volume,
            effective_last_fill_volume,
            effective_additional_manual_exchange_volume
          ].compact.inject(0, :+)
          vol == 0 ? nil : vol
        end

        def volume_of_glucose_at(percent:)
          raise "Overnight volume must be calculated first" unless overnight_volume.present?
          GlucoseCalculator.new(regime: self, percent: percent).glucose_content
        end

        private

        def effective_last_fill_volume
          has_last_fill_bag? ? last_fill_volume : 0
        end

        def effective_additional_manual_exchange_volume
          has_additional_manual_exchange_bag? ? additional_manual_exchange_volume : 0
        end
      end
    end
  end
end
