require "rails_helper"

module Renalware
  describe AutomaticAgeCalculator, type: :model do
    let(:existing_age) { nil }
    let(:age_on_date) { Time.zone.today }

    subject do
      AutomaticAgeCalculator.new(existing_age, born_on: born_on, age_on_date: age_on_date)
    end

    describe "#compute" do
      context "born_on is provided" do
        let(:born_on) { 45.years.ago.to_date }

        it "returns a computed age" do
          age = subject.compute
          expect(age.amount).to eq(45)
          expect(age.unit).to eq(:years)
        end
      end

      context "born_on is blank" do
        let(:born_on) { nil }
        let(:existing_age) { Age.new_from(years: 4, months: 1, days: 0) }

        it "returns the age unmodified" do
          age = subject.compute
          expect(age).to eq(existing_age)
        end
      end
    end
  end
end