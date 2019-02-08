# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe BloodPressure do
    describe "#blank?" do
      it "returns true if systolic and diastolic are blank" do
        expect(BloodPressure.new.blank?).to be(true)
      end

      it "returns false if systolic or diastolic are not blank" do
        expect(BloodPressure.new(systolic: 123).blank?).to be(false)
      end
    end

    describe "<==>" do
      context "when values are missing" do
        it "they count as 'high' values" do
          bp1 =  BloodPressure.new(systolic: 140, diastolic: 80)
          bp2 =  BloodPressure.new(systolic: "", diastolic: 100)
          bp3 =  BloodPressure.new(systolic: "", diastolic: "")

          expect([bp1, bp2, bp3].min).to eq(bp1)
        end
      end

      context "when other values are null" do
        it "they count as 'high' values" do
          bp1 =  BloodPressure.new(systolic: nil, diastolic: nil)
          bp2 =  BloodPressure.new(systolic: 140, diastolic: 80)
          bp3 =  BloodPressure.new(systolic: nil, diastolic: nil)

          expect([bp1, bp2, bp3].min).to eq(bp2)
        end
      end

      it "compares first by systolic" do
        bp1 =  BloodPressure.new(systolic: 140, diastolic: 80)
        bp2 =  BloodPressure.new(systolic: 120, diastolic: 100)
        bp3 =  BloodPressure.new(systolic: 130, diastolic: 80)

        expect([bp1, bp2, bp3].min).to eq(bp2)
      end

      it "or if systolic the same compares next by diastolic" do
        bp1 =  BloodPressure.new(systolic: 140, diastolic: 100)
        bp2 =  BloodPressure.new(systolic: 140, diastolic: 80)
        bp3 =  BloodPressure.new(systolic: 140, diastolic: 90)

        expect([bp1, bp2, bp3].min).to eq(bp2)
      end
    end
  end
end
