require_dependency "renalware/pd"
require "./lib/numeric_inclusion_validator"

module Renalware
  module PD
    class APDRegime < Regime
      include OrderedScope
      include PatientScope

      alias_attribute :tidal?, :tidal_indicator?
      alias_attribute :cycles, :no_cycles_per_apd
      alias_attribute :drain_every_three_cycles?, :tidal_full_drain_every_three_cycles?

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
                numeric_inclusion: { in: VALID_RANGES.tidal_percentages },
                if: :tidal?

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

      before_save -> { APD::CalculateOvernightVolume.new(self).call }

      def pd_type
        :apd
      end

      def has_additional_manual_exchange_bag?
        has_bag_with_role?(:additional_manual_exchange)
      end

      def has_last_fill_bag?
        has_bag_with_role?(:last_fill)
      end

      private

      def has_bag_with_role?(role)
        bags.select{ |bag| bag.role.public_send(:"#{role}?") }.any?
      end
    end
  end
end
