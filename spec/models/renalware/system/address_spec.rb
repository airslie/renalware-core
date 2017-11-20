require "rails_helper"

module Renalware
  describe Address, type: :model do
    describe "uk?" do
      it "responds with true if the country is in the UK" do
        expect(Address.new(country: build(:united_kingdom))).to be_uk
      end

      it "responds with false country is missing" do
        expect(Address.new(country: nil)).not_to be_uk
      end

      it "responds with false country is not in the UK" do
        expect(Address.new(country: build(:algeria))).not_to be_uk
      end
    end
  end
end
