require 'rails_helper'

RSpec.describe PdRegime, type: :model do

  it { should belong_to :patient }

  it { should have_many :pd_regime_bags }
  it { should have_many(:bag_types).through(:pd_regime_bags) }

  it { should validate_presence_of :start_date }
  it { should validate_presence_of :treatment }


  describe "type_apd?" do
    before do
      @capd_regime = create(:capd_regime)
      @apd_regime = create(:apd_regime)
    end

    context "if PD type is ApdRegime" do
      before { allow(@apd_regime).to receive(:type_apd?).and_return(true) }
      it { expect(@apd_regime).to validate_numericality_of(:last_fill_ml).is_greater_than_or_equal_to(500).is_less_than_or_equal_to(5000) }
      it { expect(@apd_regime).to validate_numericality_of(:tidal_percentage).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
      it { expect(@apd_regime).to validate_numericality_of(:no_cycles_per_apd).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(20) }
      it { expect(@apd_regime).to validate_numericality_of(:overnight_pd_ml).is_greater_than_or_equal_to(3000).is_less_than_or_equal_to(25000) }
    end

    context "if PD type is CapdRegime" do
      before { allow(@capd_regime).to receive(:type_apd?).and_return(false) }
      it { expect(@capd_regime).to_not validate_numericality_of(:last_fill_ml).is_greater_than_or_equal_to(500).is_less_than_or_equal_to(5000) }
      it { expect(@capd_regime).to_not validate_numericality_of(:tidal_percentage).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
      it { expect(@capd_regime).to_not validate_numericality_of(:no_cycles_per_apd).is_greater_than_or_equal_to(2).is_less_than_or_equal_to(20) }
      it { expect(@capd_regime).to_not validate_numericality_of(:overnight_pd_ml).is_greater_than_or_equal_to(3000).is_less_than_or_equal_to(25000) }
    end
  end

end
