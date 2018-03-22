# frozen_string_literal: true

require "rails_helper"

module Renalware::Events
  describe Event, type: :model do
    subject(:event) { described_class.new }

    it_behaves_like "an Accountable model"
    it { is_expected.to validate_presence_of(:patient) }
    it { is_expected.to validate_presence_of(:date_time) }
    it { is_expected.to validate_presence_of(:event_type_id) }
    it { is_expected.to respond_to(:type) }
    it { is_expected.to belong_to(:patient).touch(true) }

    it { is_expected.to validate_timeliness_of(:date_time) }

    describe "#document jsonb" do
      subject { event.document }

      it { is_expected.to be_nil }
      it { is_expected.to be_a(Renalware::NullObject) }
    end
  end
end
