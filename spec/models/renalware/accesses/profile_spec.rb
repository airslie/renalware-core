require "rails_helper"

module Renalware
  module Accesses
    describe Profile do
      it { is_expected.to validate_presence_of(:type) }
      it { is_expected.to validate_presence_of(:site) }
      it { is_expected.to validate_presence_of(:side) }
      it { is_expected.to validate_presence_of(:formed_on) }

      it { is_expected.to validate_timeliness_of(:formed_on) }
      it { is_expected.to validate_timeliness_of(:started_on) }
      it { is_expected.to validate_timeliness_of(:terminated_on) }
      it { is_expected.to validate_timeliness_of(:planned_on) }

      context "when plan is provided" do
        let(:plan) { create(:access_plan) }
        let(:profile) { Profile.new(plan: plan) }

        it "validates presence of planned_on" do
          expect(profile).to_not be_valid
          expect(profile.errors.keys).to include(:planned_on)
        end

        it "validates presence of decided_by" do
          expect(profile).to_not be_valid
          expect(profile.errors.keys).to include(:decided_by)
        end
      end
    end
  end
end