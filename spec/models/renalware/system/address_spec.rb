require "rails_helper"

module Renalware
  describe Address, type: :model do
    describe "uk?" do
      it "responds with true if the country is in the UK" do
        ["united kingdom", "england", "scotland", "wales", "northern ireland"].each do |country|
          expect(Address.new(country: country).uk?).to be_truthy
        end
      end

      it "responds with false country is missing" do
        expect(Address.new(country: nil).uk?).to be_falsey
      end

      it "responds with false country is not in the UK" do
        expect(Address.new(country: "Jersey").uk?).to be_falsey
      end
    end
  end
end
