require 'rails_helper'

module Renalware
  RSpec.describe PDRegimesHelper, type: :helper do

    describe 'pd_bag_volume_options' do
      it 'should produce options between 1000 and 4000, incrementing by 250' do
        expect(pd_bag_volume_options).to eq(
          [1000, 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250, 3500, 3750, 4000]
        )
      end
    end

    describe 'tidal_options' do
      it 'should produce options between 60 and 100, incrementing by 5' do
        expect(tidal_options).to eq([60, 65, 70, 75, 80, 85, 90, 95, 100])
      end
    end

    describe 'default_daily_glucose_average' do
      before do
        @patient = create(:patient)

        @bag_type_13_6 = create(:bag_type,
                      manufacturer: 'Baxter',
                      description: 'Dianeal PD2 1.36% (Yellow)',
                      glucose_grams_per_litre: 13.6)

        @bag_type_22_7 = create(:bag_type,
                      manufacturer: 'Baxter',
                      description: 'Dianeal PD2 2.27% (Green)',
                      glucose_grams_per_litre: 22.7)

        @bag_type_38_6 = create(:bag_type,
                      manufacturer: 'Baxter',
                      description: 'Dianeal PD2 3.86% (Red)',
                      glucose_grams_per_litre: 38.6)

        @capd_regime = build(:capd_regime)

        @pd_regime_bag_13_6_1 = build(:pd_regime_bag,
                                bag_type: @bag_type_13_6,
                                volume: 1500,
                                sunday: false,
                                monday: true,
                                tuesday: false,
                                wednesday: true,
                                thursday: true,
                                friday: false,
                                saturday: false)

        @pd_regime_bag_13_6_2 = build(:pd_regime_bag,
                                bag_type: @bag_type_13_6,
                                volume: 1500,
                                sunday: false,
                                monday: true,
                                tuesday: false,
                                wednesday: true,
                                thursday: false,
                                friday: false,
                                saturday: false)

        @pd_regime_bag_22_7 = build(:pd_regime_bag,
                                bag_type: @bag_type_22_7,
                                volume: 2500,
                                sunday: false,
                                monday: true,
                                tuesday: true,
                                wednesday: false,
                                thursday: true,
                                friday: true,
                                saturday: true)

        @capd_regime.pd_regime_bags << @pd_regime_bag_13_6_1
        @capd_regime.pd_regime_bags << @pd_regime_bag_13_6_2
        @capd_regime.pd_regime_bags << @pd_regime_bag_22_7

        @capd_regime.save
      end

      context 'has a glucose volume' do
        it 'should return a glucose volume' do
          expect(default_daily_glucose_average(@capd_regime.glucose_ml_percent_1_36)).to eq(1071)
          expect(default_daily_glucose_average(@capd_regime.glucose_ml_percent_2_27)).to eq(1786)
        end
      end

      context 'has no glucose volume' do
        it 'should display "0"' do
          expect(default_daily_glucose_average(@capd_regime.glucose_ml_percent_3_86)).to eq(0)
        end
      end
    end

  end
end
