require_dependency "renalware/pd"
require "./lib/numeric_inclusion_validator"

module Renalware
  module PD
    class APDRegime < Regime
      include OrderedScope
      include PatientScope

      VALID_RANGES = OpenStruct.new(
        therapy_times: (120..900).step(30).to_a,
        fill_volumes: 0..2_500,
        last_fill_volumes: 500..5_000,
        additional_manual_exchange_volumes: 500..5_000,
        cycles_per_apd: 2..20,
        overnight_pd_volumes: 3_000..25_000,
        tidal_percentages: (60..100).step(5).to_a
      ).freeze

      validates :fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.fill_volumes }

      validates :last_fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.last_fill_volumes }

      validates :additional_manual_exchange_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.additional_manual_exchange_volumes }

      validates :tidal_percentage,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.tidal_percentages }

      validates :no_cycles_per_apd,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_RANGES.cycles_per_apd

      validates :overnight_pd_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_RANGES.overnight_pd_volumes

      validates :therapy_time,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_RANGES.therapy_times }

      def pd_type
        :apd
      end

      def has_additional_manual_exchange_bag?
        regime_bags.select{ |bag| bag.role.additional_manual_exchange? }.any?
      end
    end
  end
end
