require "rails_helper"

module Renalware
  module HD
    RSpec.describe Profile, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_presence_of(:prescriber) }

      context "when schedule is other" do
        let(:profile) { Profile.new(schedule: :other) }

        it "validates presence of other_schedule" do
          expect(profile).to_not be_valid
          expect(profile.errors.keys).to include(:other_schedule)
        end
      end
    end
  end
end
