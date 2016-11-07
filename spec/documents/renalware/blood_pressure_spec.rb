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
  end
end
