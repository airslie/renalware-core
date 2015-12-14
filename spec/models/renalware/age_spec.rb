require "rails_helper"

module Renalware
  describe Age, type: :model do

    describe "#valid?" do
      subject { Age.new }

      context "born in the last 3 years" do
        it "returns false if age unit is :months" do
          subject.amount = 2
          subject.unit = :years

          expect(subject).to_not be_valid
        end
      end
    end

    describe ".new_from" do
      let(:parts) { { years: 10, months: 1, days: 2 } }

      subject { Age }

      context "params are blank" do
        let(:parts) { { years: nil, months: nil, days: nil } }

        it "returns a blank age" do
          age = subject.new_from(parts)
          expect(age.amount).to be_nil
          expect(age.unit).to be_nil
        end
      end

      context "born more that 3 years ago" do
        before do
          allow(Age).to receive(:age_in_months_threshold).and_return(parts[:years] - 1)
        end

        it "computes the age in years" do
          age = subject.new_from(parts)

          expect(age.amount).to eq(10)
          expect(age.unit).to eq(:years)
        end
      end

      context "born in the last 3 years" do
        before do
          allow(Age).to receive(:age_in_months_threshold).and_return(parts[:years] + 1)
        end

        it "computes the age in months if less than 3 years old" do
          age = subject.new_from(parts)

          expect(age.amount).to eq(10*12 + 1)
          expect(age.unit).to eq(:months)
        end
      end
    end
  end
end