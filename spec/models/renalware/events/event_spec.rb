require "rails_helper"

module Renalware::Events
  describe Event, type: :model do
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:date_time) }
    it { is_expected.to validate_presence_of(:event_type_id) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to belong_to(:patient).touch(true) }

    it { is_expected.to validate_timeliness_of(:date_time) }

    describe "#document" do
      it "returns a NullObject because there is no jsonb document on this class" do
        expect(subject.document).to be_nil
        expect(subject.document).to be_a(Renalware::NullObject)
      end
    end
  end
end
