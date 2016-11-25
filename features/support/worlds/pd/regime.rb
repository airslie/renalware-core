module World
  module PD::Regime
    module Domain
      def regime_for_patient_is_current(patient:, regime:)
        expect(regime).to eq(patient.pd_regimes.current.first)
      end
    end

    module Web
      include Domain

    end
  end
end
