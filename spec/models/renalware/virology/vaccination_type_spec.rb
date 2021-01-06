# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Virology::VaccinationType, type: :model do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to have_db_index(:name).unique(true) }
    it { is_expected.to have_db_index(:code).unique(true) }

    it "defaults position to 0" do
      type = described_class.create!(name: "X", code: "X")

      expect(type.position).to eq(0)
    end

    describe "uniqueness" do
      subject { described_class.new(name: "X", code: "X") }

      it { is_expected.to validate_uniqueness_of(:name) }
      it { is_expected.to validate_uniqueness_of(:code) }
    end

    describe "#ordered" do
      it do
        described_class.create!(name: "A", code: "A", position: 0)
        described_class.create!(name: "C", code: "C", position: 2)
        described_class.create!(name: "B", code: "B", position: 1)
        described_class.create!(name: "D", code: "D", position: 1)

        codes = described_class.ordered.all.map(&:code)
        expect(codes).to eq(%w(A B D C))
      end
    end
  end
end
