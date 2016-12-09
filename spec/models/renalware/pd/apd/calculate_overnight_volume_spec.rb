require "rails_helper"

module Renalware
  module PD
    module APD
      describe CalculateOvernightVolume do
        let(:patient) { create(:pd_patient) }

        describe "#call" do
          it "uses non tidal calculations when the regime is not tidal" do
            expect_any_instance_of(NonTidalRegimeCalculations)
              .to receive(:overnight_volume)
              .and_return(100)
            regime = build(:apd_regime, tidal_indicator: false)

            CalculateOvernightVolume.new(regime).call

            expect(regime.overnight_pd_volume).to eq(100)
          end
          it "uses tidal calculations when the regime is tidal" do
            expect_any_instance_of(TidalRegimeCalculations)
              .to receive(:overnight_volume)
              .and_return(100)
            regime = build(:apd_regime, tidal_indicator: true)

            CalculateOvernightVolume.new(regime).call

            expect(regime.overnight_pd_volume).to eq(100)
          end
        end
      end
    end
  end
end
