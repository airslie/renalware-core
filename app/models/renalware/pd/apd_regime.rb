require_dependency "renalware/pd"
require "./lib/numeric_inclusion_validator"

module Renalware
  module PD
    class APDRegime < Regime
      VALID_THERAPY_TIMES = (120..900).step(30).to_a
      VALID_FILL_VOLUMES = 0..2_500
      VALID_LAST_FILL_VOLUMES = 500..5_000
      VALID_CYCLES_PER_APD = 2..20
      VALID_OVERNIGHT_PD_VOLUMES = 3_000..25_000
      VALID_TIDAL_PERCENTAGES = (60..100).step(5).to_a

      include OrderedScope
      include PatientScope

      validates :fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_FILL_VOLUMES }

      validates :last_fill_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_LAST_FILL_VOLUMES }

      validates :tidal_percentage,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_TIDAL_PERCENTAGES }

      validates :no_cycles_per_apd,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_CYCLES_PER_APD

      validates :overnight_pd_volume,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: VALID_OVERNIGHT_PD_VOLUMES

      validates :therapy_time,
                allow_nil: true,
                numericality: { only_integer: true },
                numeric_inclusion: { in: VALID_THERAPY_TIMES }

      def apd?
        true
      end
    end
  end
end
