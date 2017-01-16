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
          return 0 unless last_fill_volume && has_last_fill_bag?
          average_daily_volume_for_bags_with_role(:last_fill, useable_volume: last_fill_volume)
        end

        def effective_additional_manual_exchange_volume
          return 0 unless additional_manual_exchange_volume && has_additional_manual_exchange_bag?
          average_daily_volume_for_bags_with_role(:additional_manual_exchange,
                                                  useable_volume: additional_manual_exchange_volume)
        end

        def average_daily_volume_for_bags_with_role(role, useable_volume:)
          selector = "#{role}?".to_sym
          role_bags = bags.select(&selector)
          avg_days_per_week = role_bags.sum(&:days_per_week).to_f / role_bags.count.to_f
          ((avg_days_per_week * useable_volume) / 7.to_f).to_i
        end
      end
    end
  end
end
