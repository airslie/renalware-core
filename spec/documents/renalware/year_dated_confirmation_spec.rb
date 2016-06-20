require "rails_helper"

module Renalware
  describe YearDatedConfirmation, type: :model do
    subject(:year_dated_confirmation) { YearDatedConfirmation.new(status: "yes", confirmed_on_year: 2015) }

    describe "#to_s" do
      context "given a completed confirmation" do
        it {
          expect(year_dated_confirmation.to_s).to eq("Yes (2015)")
        }
      end

      context "given year is missing" do
        before { year_dated_confirmation.confirmed_on_year = nil }

        it "returns blank" do
          expect(year_dated_confirmation.to_s).to eq("yes")
        end
      end

      context "given status is missing" do
        before { year_dated_confirmation.status = nil }

        it "returns blank" do
          expect(year_dated_confirmation.to_s).to eq("(2015)")
        end
      end
    end
  end
end
