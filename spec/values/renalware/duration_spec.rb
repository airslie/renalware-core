require "rails_helper"

module Renalware
  describe Duration, type: :model do
    subject { Duration }

    describe "#new" do
      it "stores the value is seconds" do
        expect(subject.new(60).seconds).to eq(60)
      end

      it "keeps a nil value" do
        expect(subject.new(nil).seconds).to be_nil
      end
    end

    describe ".from_string" do
      it "returns a duration in seconds" do
        expect(subject.from_string("0:10").seconds).to eq(600)
        expect(subject.from_string("10").seconds).to eq(600)
        expect(subject.from_string("1:00").seconds).to eq(3600)
      end

      it "keeps a nil value" do
        expect(subject.from_string("").seconds).to be_nil
      end
    end

    describe "#to_s" do
      it "returns the duration formatted in hours:minutes" do
        expect(subject.new(600).to_s).to eq("0:10")
        expect(subject.new(3600).to_s).to eq("1:00")
        expect(subject.new(30 * 3600).to_s).to eq("30:00")
      end
    end
  end
end
