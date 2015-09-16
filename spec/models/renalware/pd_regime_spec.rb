require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe PdRegime, type: :model do

    it { should belong_to :patient }

    it { should have_many :pd_regime_bags }
    it { should have_many(:bag_types).through(:pd_regime_bags) }

    it { should validate_presence_of :start_date }
    it { should validate_presence_of :treatment }

    describe 'daily average glucose calculations from bags assigned during one week', :type => :feature do
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

        login_as_clinician

        visit pd_info_patient_path(@patient)

        click_link 'Add CAPD Regime'

        select 'CAPD 3 exchanges per day', from: 'Treatment'

        select '2015', from: 'pd_regime_start_date_1i'
        select 'April', from: 'pd_regime_start_date_2i'
        select '18', from: 'pd_regime_start_date_3i'

        #bag 1
        find('input.add-bag').click

        within('body fieldset #new_pd_regime div#pd-regime-bags div.fields:nth-child(1)') do
          select 'Dianeal PD2 1.36% (Yellow)', from: 'Bag Type'

          fill_in 'Volume (ml)', with: 2000

          uncheck 'Monday'
          uncheck 'Wednesday'
          uncheck 'Friday'
          uncheck 'Saturday'
        end

        #bag 2
        find('input.add-bag').click

        within('body fieldset #new_pd_regime div#pd-regime-bags div.fields:nth-child(2)') do
          select 'Dianeal PD2 2.27% (Green)', from: 'Bag Type'

          fill_in 'Volume (ml)', with: 3000

          uncheck 'Tuesday'
          uncheck 'Thursday'
        end

        #bag 3
        find('input.add-bag').click

        within('body fieldset #new_pd_regime div#pd-regime-bags div.fields:nth-child(3)') do
          select 'Dianeal PD2 3.86% (Red)', from: 'Bag Type'

          fill_in 'Volume (ml)', with: 1500

          uncheck 'Sunday'
          uncheck 'Wednesday'
          uncheck 'Friday'
        end

        #bag 4
        find('input.add-bag').click

        within('body fieldset #new_pd_regime div#pd-regime-bags div.fields:nth-child(4)') do
          select 'Dianeal PD2 3.86% (Red)', from: 'Bag Type'

          fill_in 'Volume (ml)', with: 2000

          uncheck 'Monday'
          uncheck 'Wednesday'
          uncheck 'Friday'
          uncheck 'Saturday'
        end

        click_on 'Save CAPD Regime'
      end

      context '1.36 %' do
        it 'should return daily average volume (ml)' do
          expect(page).to have_content("1.36 %: 857 ml")
        end
      end

      context '2.27 %' do
        it 'should return daily average volume (ml)' do
          expect(page).to have_content("2.27 %: 2143 ml")
        end
      end

      context '3.86 %' do
        it 'should return daily average volume (ml)' do
          expect(page).to have_content("3.86 %: 1714 ml")
        end
      end
    end

    describe 'creating a regime without a bag', :type => :feature do
      context 'CAPD' do
        it 'should fail validation and display appropriate error message' do
          @patient = create(:patient)
          login_as_clinician
          visit pd_info_patient_path(@patient)

          click_link 'Add CAPD Regime'

          select 'CAPD 3 exchanges per day', from: 'Treatment'

          click_on 'Save CAPD Regime'

          expect(page).to have_content('PD regime must be assigned at least one bag')
        end
      end
    end

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

    # describe 'PD regime validation custom error messages', :type => :feature do
    #   context 'CAPD' do
    #     it 'should display custom error messages when a CAPD regime fails validation' do
    #       @patient = create(:patient)
    #       login_as_clinician
    #       visit pd_info_patient_path(@patient)

    #       click_link 'Add CAPD Regime'

    #       find('input.add-bag').click

    #       uncheck 'Sunday'
    #       uncheck 'Monday'
    #       uncheck 'Tuesday'
    #       uncheck 'Wednesday'
    #       uncheck 'Thursday'
    #       uncheck 'Friday'
    #       uncheck 'Saturday'

    #       click_on 'Save CAPD Regime'

    #       expect(page).to have_content("PD bag type can't be blank")
    #       expect(page).to have_content("PD bag volume (ml) can't be blank")
    #       expect(page).to have_content("PD bag must be assigned at least one day of the week")
    #       expect(page).to have_content("PD regime treatment can't be blank")
    #     end
    #   end

    #   context 'APD' do
    #     it 'should display custom error messages when a APD regime fails validation' do
    #       @patient = create(:patient)
    #       login_as_clinician
    #       visit pd_info_patient_path(@patient)

    #       click_link 'Add APD Regime'

    #       find('input.add-bag').click

    #       uncheck 'Sunday'
    #       uncheck 'Monday'
    #       uncheck 'Tuesday'
    #       uncheck 'Wednesday'
    #       uncheck 'Thursday'
    #       uncheck 'Friday'
    #       uncheck 'Saturday'

    #       click_on 'Save APD Regime'

    #       expect(page).to have_content("PD bag type can't be blank")
    #       expect(page).to have_content("PD bag volume (ml) can't be blank")
    #       expect(page).to have_content("PD bag must be assigned at least one day of the week")
    #       expect(page).to have_content("PD regime treatment can't be blank")
    #     end
    #   end
    # end

  end
end