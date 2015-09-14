require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe PdRegimeBag, :type => :model do

    it { should belong_to :bag_type }
    it { should belong_to :pd_regime }

    it { should validate_presence_of :bag_type_id }
    it { should validate_presence_of :volume }

    it { should validate_numericality_of(:volume).is_greater_than_or_equal_to(100).is_less_than_or_equal_to(10000).allow_nil }

    before do
      @patient = create(:patient)
      @pd_regime_bag_1 = PdRegimeBag.new
      @pd_regime_bag_2 = build(:pd_regime_bag,
                          sunday: true,
                          monday: false,
                          tuesday: true,
                          wednesday: false,
                          thursday: false,
                          friday: true,
                          saturday: false
                        )
    end

    describe 'initialize', :type => :feature do
      before do
        login_as_clinician
      end

      context 'without changed day values' do
        it 'should set all default values for days of the week to be true' do
          expect(@pd_regime_bag_1.monday).to eq(true)
          expect(@pd_regime_bag_1.tuesday).to eq(true)
          expect(@pd_regime_bag_1.wednesday).to eq(true)
          expect(@pd_regime_bag_1.thursday).to eq(true)
          expect(@pd_regime_bag_1.friday).to eq(true)
          expect(@pd_regime_bag_1.saturday).to eq(true)
          expect(@pd_regime_bag_1.sunday).to eq(true)
        end
      end

      context 'with changed day values' do
        it 'should save changes made to default days of the week.' do
          visit new_patient_pd_regime_path(@patient, type: 'CapdRegime')

          select '2015', from: 'pd_regime_start_date_1i'
          select 'May', from: 'pd_regime_start_date_2i'
          select '25', from: 'pd_regime_start_date_3i'

          select 'CAPD 3 exchanges per day', from: 'Treatment'

          find("input.add-bag").click

          select 'Star Brand, Lucky Brand Green–2.34', from: 'Bag Type'

          fill_in 'Volume', with: '230'

          uncheck 'Tuesday'

          uncheck 'Thursday'

          click_on 'Save CAPD Regime'

          within '.current-regime' do
            expect(page).to have_content("Days: Sun, Mon, Wed, Fri, Sat")
          end
        end
      end
    end

    describe 'days' do
      it 'should return days of the week which have been checked as true or false' do
        expect(@pd_regime_bag_2.days).to eq([true, false, true, false, false, true, false])
      end
    end

    describe 'days_to_sym' do
      it 'should convert rails date daynames module to become lowercase and to symbol' do
        expect(@pd_regime_bag_1.days_to_sym).to eq([:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday])
      end
    end
  end
end