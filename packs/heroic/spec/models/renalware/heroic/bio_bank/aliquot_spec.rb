# frozen_string_literal: true

require "rails_helper"

module Renalware::Heroic
  RSpec.describe BioBank::Aliquot do
    it_behaves_like "an Accountable model"
    it_behaves_like "a Paranoid model"
    it { is_expected.to be_versioned }
    it { is_expected.to belong_to(:sample) }
    it { is_expected.to have_one(:usage) }
    it { is_expected.to validate_presence_of(:sample) }

    context "when an aliquote has not been used" do
      describe "#used?" do
        subject { build_stubbed(:bio_bank_aliquot).used? }

        it { is_expected.to be(false) }
      end
    end

    context "when an aliquote has been used" do
      subject(:aliquot) { build_stubbed(:bio_bank_aliquot, :used) }

      it "has an associated usage" do
        expect(aliquot.usage.usable).to eq(aliquot)
      end

      describe "#used?" do
        subject { aliquot.used? }

        it { is_expected.to be(true) }
      end
    end
  end
end
