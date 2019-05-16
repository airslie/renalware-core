# frozen_string_literal: true

require "rails_helper"

module Renalware
  describe Modalities::Description, type: :model do
    it_behaves_like "a Paranoid model"
    it { is_expected.to validate_presence_of :name }

    describe "#validation" do
      subject { described_class.new(name: "P") }

      it { is_expected.to validate_uniqueness_of :name }
    end

    describe "#augmented_name_for(patient)" do
      subject { described_class.new(name: "XYZ").augmented_name_for(patient) }

      let(:patient) { nil }

      it "defaults to returning the modality name (a subclass may override to change behaviour)" do
        expect(subject).to eq("XYZ")
      end
    end
  end
end
