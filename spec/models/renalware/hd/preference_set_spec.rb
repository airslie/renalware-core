require "rails_helper"

module Renalware
  module HD
    RSpec.describe PreferenceSet, type: :model do
      it { is_expected.to validate_presence_of(:patient) }
      it { is_expected.to validate_timeliness_of(:entered_on) }
      it { is_expected.to belong_to(:patient).touch(true) }

      context "when schedule is other" do
        let(:preference_set) { PreferenceSet.new(schedule: :other) }

        it "validates presence of other_schedule" do
          expect(preference_set).not_to be_valid
          expect(preference_set.errors.keys).to include(:other_schedule)
        end
      end
    end
  end
end
