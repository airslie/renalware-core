require "rails_helper"

module Renalware
  describe Age, type: :model do

    let(:birthdate) { Date.parse("2013/01/01") }
    let(:now) { Time.zone.today }

    subject { Age.new }

    describe "#valid?" do
      context "born in the last 3 years" do
        it "returns false if age unit is :months" do
          subject.amount = 2
          subject.unit = :years

          expect(subject).to_not be_valid
        end
      end
    end

    describe "#set_from_dates" do
      context "birthdate is blank" do
        let(:birthdate) { nil }

        subject { Age.new(amount: 11, unit: :years) }

        it "does not modify the age" do
          subject.set_from_dates(birthdate, now)
          expect(subject.amount).to eq(11)
        end
      end

      context "datestamp is blank" do
        let(:now) { nil }

        subject { Age.new(amount: 11, unit: :years) }

        it "does not modify the age" do
          subject.set_from_dates(birthdate, now)
          expect(subject.amount).to eq(11)
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