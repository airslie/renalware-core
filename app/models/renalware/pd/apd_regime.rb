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
                numericality: {
                  greater_than_or_equal_to: 0,
                  less_than_or_equal_to: 2500
                }
      validates :last_fill_volume,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: 500,
                  less_than_or_equal_to: 5000
                }
      validates :tidal_percentage,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: 0,
                  less_than_or_equal_to: 100
                }
      validates :no_cycles_per_apd,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: 2,
                  less_than_or_equal_to: 20
                }
      validates :overnight_pd_volume,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: 3000,
                  less_than_or_equal_to: 25000
                }
      validates :therapy_time,
                allow_nil: true,
                numericality: {
                  greater_than_or_equal_to: MIN_THERAPY_TIME,
                  less_than_or_equal_to: MAX_THERAPY_TIME
                }

      def apd?
        false
      end
    end
  end
end
