require "rails_helper"

module Renalware
  describe Age, type: :model do

    let(:birthdate) { Date.parse("2013/01/01") }
    let(:now) { Time.zone.today }

    subject { Age.new(amount: 11, unit: :years) }

    describe "#set_from_dates" do
      context "birthdate is blank" do
        let(:birthdate) { nil }

        it "does not modify the age" do
          subject.set_from_dates(birthdate, now)
          expect(subject.amount).to be_nil
        end
      end

      context "datestamp is blank" do
        let(:now) { nil }

        it "does not modify the age" do
          subject.set_from_dates(birthdate, now)
          expect(subject.amount).to be_nil
        end
      end

      context "born more that 3 years ago" do
        let(:birthdate) { 45.years.ago.to_date }

        it "computes the age in years" do
          subject.set_from_dates(birthdate, now)

          expect(subject.amount).to eq(45)
          expect(subject.unit).to eq(:years)
        end
      end

      context "born in the last 3 years" do
        let(:birthdate) { 35.months.ago.to_date }

        it "computes the age in months if less than 3 years old" do
          subject.set_from_dates(birthdate, now)

          expect(subject.amount).to eq(35)
          expect(subject.unit).to eq(:months)
        end
      end
    end
  end
end