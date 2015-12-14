require "rails_helper"

module Renalware
  describe Duration, type: :model do
    subject { Duration }

    describe "#new" do
      it "sets keeps the nil value" do
        expect(subject.new(nil).in_seconds).to be_nil
        expect(subject.new("").in_seconds).to be_nil
      end
    end

    describe "#in_seconds" do
      it "returns the duration in seconds" do
        expect(subject.new("0:10").in_seconds).to eq(600)
        expect(subject.new("10").in_seconds).to eq(600)
        expect(subject.new("1:00").in_seconds).to eq(3600)
      end
    end

    describe "#to_s" do
      it "returns the duration formatted in hours:minutes" do
        expect(subject.new(600).to_s).to eq("0:10")
        expect(subject.new(3600).to_s).to eq("1:00")
        expect(subject.new(30*3600).to_s).to eq("30:00")
      end
    end
  end
end
