module Renalware
  module PD
    class MDMPresenter < Renalware::MDMPresenter
      def current_regime
        @current_regime ||= patient.pd_regimes&.current
      end
    end
  end
end
