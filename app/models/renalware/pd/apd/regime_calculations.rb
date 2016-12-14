require_dependency "renalware/pd"

module Renalware
  module PD
    module APD
      class RegimeCalculations < SimpleDelegator
        INCALCULABLE = nil

        def calculated_overnight_volume
          raise NotImplementedAError
        end

        def calculated_daily_volume
          vol = [
            calculated_overnight_volume,
            effective_last_fill_volume,
            effective_additional_manual_exchange_volume
          ].compact.inject(0, :+)
          vol == 0 ? nil : vol
        end

        private

        def effective_last_fill_volume
          (last_fill_volume && has_last_fill_bag?) ? last_fill_volume : 0
        end

        def effective_additional_manual_exchange_volume
          return unless additional_manual_exchange_volume && has_additional_manual_exchange_bag?
          additional_manual_exchange_volume
        end
      end
    end
  end
end
