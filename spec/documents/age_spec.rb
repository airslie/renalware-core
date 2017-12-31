require "rails_helper"

module Renalware
  describe Age, type: :model do
    describe "#valid?" do
      context "when born in the last 3 years" do
        it "returns false if age unit is :months" do
          age = Age.new(amount: 2, unit: :years)

          expect(age).not_to be_valid
        end
      end
    end

    describe ".new_from" do
      subject{ Age.new_from(parts) }

      context "when params are blank" do
        let(:parts){ { years: nil, months: nil, days: nil } }

        it { is_expected.to have_attributes(amount: nil) }
        it { is_expected.to have_attributes(unit: nil) }
      end

      context "when born more that 3 years ago" do
        let(:parts){ { years: 3, months: 1, days: 2 } }

        it { is_expected.to have_attributes(amount: 3) }
        it { is_expected.to have_attributes(unit: "years") }
      end

      context "when less than 3 years ago" do
        let(:parts){ { years: 2, months: 11, days: 27 } }

        it { is_expected.to have_attributes(amount: 35) }
        it { is_expected.to have_attributes(unit: "months") }
      end
    end
  end
end
