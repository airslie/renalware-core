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
    let(:global_rule_set) { create(:pathology_request_algorithm_global_rule_set) }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet).to receive(:where)
        .and_return([global_rule_set])
      allow(global_rule_set).to receive(:required_for_patient?).and_return(global_rule_set_required)
      allow(global_rule_set).to receive(:rules).and_return(global_rules)
    end

    context "a rule_set with no rules" do
      let(:global_rules) { [] }

      subject! { global_algorithm.required_pathology }

      context "rule set required" do
        let(:global_rule_set_required) { true }
        it { is_expected.to eq([global_rule_set.observation_description_id])}
      end

      context "rule set required" do
        let(:global_rule_set_required) { false }
        it { is_expected.to eq([])}
      end
    end

    context "a rule_set with multiple rules" do
      let(:global_rule_1) do
        create(
          :pathology_request_algorithm_global_rule,
          global_rule_set: global_rule_set
        )
      end
      let(:global_rule_2) do
        create(
          :pathology_request_algorithm_global_rule,
          global_rule_set: global_rule_set
        )
      end
      let(:global_rules) { [global_rule_1, global_rule_2] }

      before do
        allow(global_rule_1).to receive(:required_for_patient?).and_return(global_rule_1_required)
        allow(global_rule_2).to receive(:required_for_patient?).and_return(global_rule_2_required)
      end

      subject! { global_algorithm.required_pathology }

      context "rule_set required and all rules required" do
        let(:global_rule_set_required) { true }
        let(:global_rule_1_required) { true }
        let(:global_rule_2_required) { true }

        it { is_expected.to eq([global_rule_set.observation_description_id])}
      end

      context "rule_set required and some rules required" do
        let(:global_rule_set_required) { true }
        let(:global_rule_1_required) { true }
        let(:global_rule_2_required) { false }

        it { is_expected.to eq([])}
      end

      context "rule_set not required and rules required" do
        let(:global_rule_set_required) { false }
        let(:global_rule_1_required) { true }
        let(:global_rule_2_required) { true }

        it { is_expected.to eq([])}
      end
    end
  end
end
