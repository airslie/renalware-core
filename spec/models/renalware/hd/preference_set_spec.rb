require "rails_helper"

module Renalware
  module Hd
    RSpec.describe PreferenceSet, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_timeliness_of(:entered_on) }

      context "when schedule is other" do
        let(:preference_set) { PreferenceSet.new(schedule: :other) }

        it "validates presence of other_schedule" do
          expect(preference_set).to_not be_valid
          expect(preference_set.errors.keys).to include(:other_schedule)
        end
      end
    end
  end
end