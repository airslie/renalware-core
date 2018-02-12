require "rails_helper"

module Renalware::Pathology
  RSpec.describe ObservationDescriptionsByCodeQuery do
    let(:codes) { %w(HGB PLT) }
    let(:relation) { ObservationDescription.all }
    subject{ described_class.new(relation: relation, codes: codes).call }

    context "when codes supplied but there are no matching ObservationDescriptions" do
      it { is_expected.to be_empty }
    end

    context "when empty array of codes supplied" do
      let(:codes) { [] }

      it { is_expected.to be_empty }
    end

    context "when codes is nil" do
      let(:codes) { nil }

      it { is_expected.to be_empty }
    end
  end
end
