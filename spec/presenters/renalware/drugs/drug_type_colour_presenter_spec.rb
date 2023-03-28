# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe DrugTypeColourPresenter do
    describe "#style" do
      let(:instance) { described_class.new }
      let(:drug_types) { [] }

      subject { instance.style(drug_types) }

      context "when drug_types is empty" do
        it { is_expected.to be_nil }
      end

      context "when drug types are set" do
        let(:drug_type_1) { instance_double Type, weighting: 1, colour: "blue" }
        let(:drug_type_2) { instance_double Type, weighting: 20, colour: "red" }
        let(:drug_type_3) { instance_double Type, weighting: 6, colour: "pink" }
        let(:drug_types) { [drug_type_1, drug_type_2, drug_type_3] }

        it { is_expected.to eq "background-color: red" }
      end
    end
  end
end
