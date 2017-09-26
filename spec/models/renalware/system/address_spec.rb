require "rails_helper"

module Renalware
  describe Address, type: :model do
    describe "uk?" do
      it "responds with true if the country is in the UK" do
        expect(Address.new(country: build(:united_kingdom)).uk?).to be_truthy
      end

      it "responds with false country is missing" do
        expect(Address.new(country: nil).uk?).to be_falsey
      end

      it "responds with false country is not in the UK" do
        expect(Address.new(country: build(:algeria)).uk?).to be_falsey
      end
    end
  end
end
