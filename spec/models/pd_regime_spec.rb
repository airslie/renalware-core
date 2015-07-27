require 'rails_helper'
require './spec/support/login_macros'

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

  describe 'PD regime validation custom error messages', :type => :feature do
    context 'CAPD' do
      it 'should display custom error messages when a CAPD regime fails validation' do
        @patient = create(:patient)
        login_as_clinician
        visit pd_info_patient_path(@patient)

        click_link 'Add CAPD Regime'

        find('input.add-bag').click

        uncheck 'Sunday'
        uncheck 'Monday'
        uncheck 'Tuesday'
        uncheck 'Wednesday'
        uncheck 'Thursday'
        uncheck 'Friday'
        uncheck 'Saturday'

        click_on 'Save CAPD Regime'

        expect(page).to have_content("PD bag type can't be blank")
        expect(page).to have_content("PD regime volume (ml) can't be blank")
        expect(page).to have_content("PD regime bag must be assigned at least one day of the week")
        expect(page).to have_content("PD regime treatment can't be blank")
      end
    end

    context 'APD' do
      it 'should display custom error messages when a APD regime fails validation' do
        @patient = create(:patient)
        login_as_clinician
        visit pd_info_patient_path(@patient)

        click_link 'Add APD Regime'

        find('input.add-bag').click

        uncheck 'Sunday'
        uncheck 'Monday'
        uncheck 'Tuesday'
        uncheck 'Wednesday'
        uncheck 'Thursday'
        uncheck 'Friday'
        uncheck 'Saturday'

        click_on 'Save APD Regime'

        expect(page).to have_content("PD bag type can't be blank")
        expect(page).to have_content("PD regime volume (ml) can't be blank")
        expect(page).to have_content("PD regime bag must be assigned at least one day of the week")
        expect(page).to have_content("PD regime treatment can't be blank")
      end
    end
  end

end
