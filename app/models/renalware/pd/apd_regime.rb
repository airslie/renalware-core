require_dependency "renalware/pd"

module Renalware
  module PD
    class APDRegime < Regime
      include OrderedScope
      include PatientScope
    end
  end
end
