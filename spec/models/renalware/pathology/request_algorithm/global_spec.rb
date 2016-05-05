require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Global do
  let(:patient) { create(:patient) }
  let(:regime) { "Nephrology" }
  let(:global_algorithm) { Renalware::Pathology::RequestAlgorithm::Global.new(patient, regime) }

  describe "#initialize" do
    context "with regime param not in the array of accepted values" do
      let(:regime) { "NOT A VALID REGIME" }

      subject { global_algorithm }

      it { expect{ subject }.to raise_error ArgumentError }
    end
  end

  describe "#required_pathology" do
    let(:rule_set_1) { create(:pathology_request_algorithm_global_rule_set) }
    let(:rule_set_2) { create(:pathology_request_algorithm_global_rule_set) }
    let(:rule_sets) { [rule_set_1, rule_set_2] }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet).to receive(:where)
        .and_return(rule_sets)
      allow(rule_set_1).to receive(:required_for_patient?).and_return(true)
      allow(rule_set_2).to receive(:required_for_patient?).and_return(false)
    end

    subject { global_algorithm.required_pathology }

    it { is_expected.to eq([rule_set_1.observation_description]) }
  end
end
