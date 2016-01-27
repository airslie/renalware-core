require 'rails_helper'
require './spec/support/login_macros'

module Renalware
  RSpec.describe PDRegimeBag, type: :model do

    it { should belong_to :bag_type }
    it { should belong_to :pd_regime }

    it { should validate_presence_of :bag_type }
    it { should validate_presence_of :volume }

    it { should validate_numericality_of(:volume).is_greater_than_or_equal_to(100).is_less_than_or_equal_to(10000).allow_nil }

    before do
      @patient = create(:patient)
      @pd_regime_bag_1 = PDRegimeBag.new
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
