require_dependency "renalware/pd"

module Renalware
  module PD
    class APDRegime < Regime
      MIN_THERAPY_TIME = 120
      MAX_THERAPY_TIME = 900

      include OrderedScope
      include PatientScope

      validates :fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                inclusion: { in: 0..2_500 }

      validates :last_fill_volume,
                allow_nil: true,
                inclusion: { in: 500..5_000 },
                numericality: { only_integer: true }

      validates :tidal_percentage,
                allow_nil: true,
                inclusion: { in: 0..100 },
                numericality: { only_integer: true }

      validates :no_cycles_per_apd,
                allow_nil: true,
                inclusion: { in: 2..20 },
                numericality: { only_integer: true }

      validates :overnight_pd_volume,
                allow_nil: true,
                inclusion: { in: 3_000..25_000 },
                numericality: { only_integer: true }

      validates :therapy_time,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: MIN_THERAPY_TIME,
                  less_than_or_equal_to: MAX_THERAPY_TIME
                }

      def apd?
        true
      end
    end
  end
end
