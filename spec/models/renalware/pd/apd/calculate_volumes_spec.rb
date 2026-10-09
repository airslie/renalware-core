module Renalware
  module PD
    module APD
      describe CalculateVolumes do
        let(:patient) { build_stubbed(:pd_patient) }

        def stub_overnight_volume(calculations_class, volume)
          allow(calculations_class).to receive(:new).and_wrap_original do |original, regime|
            original.call(regime).tap do |calculations|
              allow(calculations).to receive(:calculated_overnight_volume).and_return(volume)
            end
          end
        end

        describe "#call" do
          it "uses non tidal calculations when the regime is not tidal" do
            stub_overnight_volume(NonTidalRegimeCalculations, 100)
            regime = build(:apd_regime, tidal_indicator: false)

            described_class.new(regime).call

            expect(NonTidalRegimeCalculations).to have_received(:new).with(regime)
            expect(regime.overnight_volume).to eq(100)
          end

          it "uses tidal calculations when the regime is tidal" do
            stub_overnight_volume(TidalRegimeCalculations, 100)
            regime = build(:apd_regime, tidal_indicator: true)

            described_class.new(regime).call

            expect(TidalRegimeCalculations).to have_received(:new).with(regime)
            expect(regime.overnight_volume).to eq(100)
          end
        end
      end
    end
  end
end
