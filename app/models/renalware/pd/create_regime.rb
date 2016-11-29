require_dependency "renalware/pd"

module Renalware
  module PD
    class CreateRegime
      def initialize(patient:)
        @patient = patient
      end

      def call(by:, params:)
        regime = patient.pd_regimes.new(params)
        if regime.valid?
          save_regime(regime, by)
          return Success.new(regime)
        else
          return Failure.new(regime)
        end
      end

      private

      attr_reader :patient

      def save_regime(regime, by)
        Regime.transaction do
          current_regime.terminate(by: by).save!
          regime.save!
        end
      end

      def current_regime
        patient.pd_regimes.current || NullObject.instance
      end
    end
  end
end
