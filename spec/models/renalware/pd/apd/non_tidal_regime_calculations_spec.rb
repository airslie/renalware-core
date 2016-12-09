require "rails_helper"

module Renalware
  module PD
    module APD
      describe NonTidalRegimeCalculations do
        subject { NonTidalRegimeCalculations.new(regime) }
        let(:regime) { build(:apd_regime, no_cycles_per_apd: 7, fill_volume: 1500) }

        describe "#overnight_volume" do
          it "returns 0 if fill_volumne is zero" do
            regime.fill_volume = 0
            expect(NonTidalRegimeCalculations.new(regime).overnight_volume).to eq(nil)
          end

          it "returns 0 if no_cycles_per_apd is nil" do
            regime.cycles = nil
            expect(NonTidalRegimeCalculations.new(regime).overnight_volume).to eq(nil)
          end

          it "returns the number of exchanges (cycles) * volume of each exchange (fill_volume)" do
            overnight_volume = NonTidalRegimeCalculations.new(regime).overnight_volume

            expect(overnight_volume).to eq(7 * 1500)
            expect(overnight_volume).to be_a(Integer)
            expect(regime).to_not be_tidal
          end
        end
      end
    end
  end
end
