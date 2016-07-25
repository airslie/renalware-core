require_dependency "renalware/pd"

module Renalware
  module PD
    class CAPDRegime < Regime
      include OrderedScope
      include PatientScope
    end
  end
end
