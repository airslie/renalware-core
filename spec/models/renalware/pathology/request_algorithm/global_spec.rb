require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Global do
  let(:patient) { create(:patient) }
  let(:regime) { "Nephrology" }
  let(:global_algorithm) { described_class.new(patient, regime) }

  describe "#initialize" do
    context "with regime param not in the array of accepted values" do
      let(:regime) { "NOT A VALID REGIME" }

      subject { global_algorithm }

      it { expect{ subject }.to raise_error ArgumentError }
    end
  end

  describe "#required_pathology" do
    let(:observation_description_id) { rand(100) }
    let(:global_rule_1) do
      create(
        :pathology_request_algorithm_global_rule,
        observation_description_id: observation_description_id
      )
    end
    let(:global_rule_2) do
      create(
        :pathology_request_algorithm_global_rule,
        observation_description_id: observation_description_id
      )
    end
    let(:global_rules) { [global_rule_1, global_rule_2] }

    let(:global_rule_decider_1) do
      double(Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider)
    end
    let(:global_rule_decider_2) do
      double(Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider)
    end

    before do
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRule).to receive(:where)
        .and_return(global_rules)
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider).to receive(:new)
        .and_return(global_rule_decider_1, global_rule_decider_2)
      allow(global_rule_decider_1).to receive(:observation_required?).and_return(true)
      allow(global_rule_decider_2).to receive(:observation_required?).and_return(true)
    end

    subject! { global_algorithm.required_pathology }

    it do
      expect(Renalware::Pathology::RequestAlgorithm::GlobalRule).to have_received(:where)
        .with(regime: regime)
    end
    it do
      expect(Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider).to have_received(:new)
        .with(patient, global_rule_1)
    end
    it do
      expect(Renalware::Pathology::RequestAlgorithm::GlobalRuleDecider).to have_received(:new)
        .with(patient, global_rule_2)
    end
    it { expect(global_rule_decider_1).to have_received(:observation_required?) }
    it { expect(global_rule_decider_2).to have_received(:observation_required?) }

    it { is_expected.to eq([observation_description_id])}
  end
end
