require_dependency "renalware/pd"

module Renalware
  module PD
    class CAPDRegime < Regime
      include OrderedScope
      include PatientScope

      def pd_type
        :capd
      end
    end
  end
end
