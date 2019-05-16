# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Age, type: :model do
    describe "#valid?" do
      context "when born in the last 3 years" do
        subject { Age.new(amount: 2, unit: :years) }

        it { is_expected.not_to be_valid }
      end
    end

    describe ".new_from" do
      subject { Age.new_from(parts) }

      context "when params are blank" do
        let(:parts) { { years: nil, months: nil, days: nil } }

        it { is_expected.to have_attributes(amount: nil, unit: nil) }
      end

      context "when born more that 3 years ago" do
        let(:parts) { { years: 3, months: 1, days: 2 } }

        it { is_expected.to have_attributes(amount: 3, unit: "years") }
      end

      context "when less than 3 years ago" do
        let(:parts) { { years: 2, months: 11, days: 27 } }

        it { is_expected.to have_attributes(amount: 35, unit: "months") }
      end
    end
  end
end
