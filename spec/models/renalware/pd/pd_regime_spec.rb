require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe PDRegime, type: :model do
    it { should validate_presence_of :patient }
    it { should validate_presence_of :start_date }
    it { should validate_presence_of :treatment }

    describe "type_apd?" do
      before do
        @bag_type = create(:bag_type)

        @capd_regime = create(:capd_regime,
                        pd_regime_bags_attributes: [
                          bag_type_id: @bag_type.id,
                          volume: 600,
                          sunday: true,
                          monday: true,
                          tuesday: true,
                          wednesday: true,
                          thursday: true,
                          friday: true,
                          saturday: true
                        ]
                      )
        @apd_regime = create(:apd_regime,
                        pd_regime_bags_attributes: [
                          bag_type_id: @bag_type.id,
                          volume: 600,
                          sunday: true,
                          monday: true,
                          tuesday: true,
                          wednesday: true,
                          thursday: true,
                          friday: true,
                          saturday: true
                        ]
                      )
      end

      context "if PD type is APDRegime" do
        before { allow(@apd_regime).to receive(:type_apd?).and_return(true) }
        it { expect(@apd_regime).to validate_numericality_of(:last_fill_ml).is_greater_than_or_equal_to(500).is_less_than_or_equal_to(5000) }
        it { expect(@apd_regime).to validate_numericality_of(:tidal_percentage).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
        it { expect(@apd_regime).to validate_numericality_of(:no_cycles_per_apd).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(20) }
        it { expect(@apd_regime).to validate_numericality_of(:overnight_pd_ml).is_greater_than_or_equal_to(3000).is_less_than_or_equal_to(25000) }
      end

      context "if PD type is CAPDRegime" do
        before { allow(@capd_regime).to receive(:type_apd?).and_return(false) }
        it { expect(@capd_regime).to_not validate_numericality_of(:last_fill_ml).is_greater_than_or_equal_to(500).is_less_than_or_equal_to(5000) }
        it { expect(@capd_regime).to_not validate_numericality_of(:tidal_percentage).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
        it { expect(@capd_regime).to_not validate_numericality_of(:no_cycles_per_apd).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(20) }
        it { expect(@capd_regime).to_not validate_numericality_of(:overnight_pd_ml).is_greater_than_or_equal_to(3000).is_less_than_or_equal_to(25000) }
      end
    end

  end
end
