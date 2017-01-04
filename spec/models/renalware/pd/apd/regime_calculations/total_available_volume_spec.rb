require "rails_helper"

module Renalware
  module PD
    module APD
      class MyRegimeCalculations < RegimeCalculations
        def overnight_volume
          1000
        end
      end

      describe RegimeCalculations do

        subject { MyRegimeCalculations.new(regime) }

        let(:bag_13_6) { build(:bag_type, glucose_content: 13.6) }
        let(:bag_22_7) { build(:bag_type, glucose_content: 22.7) }
        let(:bag_38_6) { build(:bag_type, glucose_content: 38.6) }
        let(:regime) { build(:apd_regime, no_cycles_per_apd: 7, fill_volume: 1500) }
        let(:regime_overnight_volume) { 7 * 1500 }

        describe "#total_available_volume" do
          it "sdsd" do

          end
        end
      end
    end
  end
end
