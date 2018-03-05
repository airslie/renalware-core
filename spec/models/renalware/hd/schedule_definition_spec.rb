# frozen_string_literal: true

require "rails_helper"

module Renalware::HD
  RSpec.describe ScheduleDefinition, type: :model do
    it { is_expected.to validate_presence_of(:days) }
    it { is_expected.to validate_presence_of(:diurnal_period_id) }
    it { is_expected.to belong_to(:diurnal_period) }

    describe "#to_s" do
      it "formats definition in eg Mon, Wed, Thur AM" do
        diurnal_period = DiurnalPeriodCode.new(code: "am")
        definition = described_class.new(days: [1, 3, 5], diurnal_period: diurnal_period)

        expect(definition.to_s).to eq("Mon Wed Fri AM")
      end
    end
  end
end
