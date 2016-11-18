require "rails_helper"
require "./spec/support/login_macros"

module Renalware
  RSpec.describe PD::RegimeBag, type: :model do
    it { should validate_presence_of :bag_type }
    it { should validate_presence_of :volume }
    it { should respond_to :additional_manual_exchange }

    it do
      should validate_numericality_of(:volume)
              .is_greater_than_or_equal_to(100)
              .is_less_than_or_equal_to(10000)
              .allow_nil
    end

    before do
      @patient = create(:patient)
      @pd_regime_bag_1 = PD::RegimeBag.new
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

    describe "days" do
      it "should return days of the week which have been checked as true or false" do
        expect(@pd_regime_bag_2.days).to eq([true, false, true, false, false, true, false])
      end
    end

    describe "days_to_sym" do
      it "should convert rails date daynames module to become lowercase and to symbol" do
        days = [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]
        expect(@pd_regime_bag_1.days_to_sym).to eq(days)
      end
    end
  end
end
