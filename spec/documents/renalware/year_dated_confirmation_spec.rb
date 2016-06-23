require "rails_helper"

module Renalware
  describe YearDatedConfirmation, type: :model do
    subject(:year_dated_confirmation) {
      YearDatedConfirmation.new(status: "yes", confirmed_on_year: 2015)
    }

    describe "#to_s" do
      context "given a completed confirmation" do
        it "returns the year and status as a string" do 
          expect(year_dated_confirmation.to_s).to eq("Yes (2015)")
        end
      end

      context "given the year is missing" do
        before { year_dated_confirmation.confirmed_on_year = nil }

        it "returns the status only as a string" do
          expect(year_dated_confirmation.to_s).to eq("Yes")
        end
      end

      context "given the status is missing" do
        before { year_dated_confirmation.status = nil }

        it "returns the year only as a string" do
          expect(year_dated_confirmation.to_s).to eq("(2015)")
        end
      end
    end
  end
end
