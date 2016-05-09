require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Global do
  let(:patient) { build(:patient) }
  let(:clinic) { build(:clinic) }

  subject { Renalware::Pathology::RequestAlgorithm::Global.new(patient, clinic) }

  describe "#required_pathology" do
    let(:rule_set_1) { build(:pathology_request_algorithm_global_rule_set) }
    let(:rule_set_2) { build(:pathology_request_algorithm_global_rule_set) }
    let(:rule_sets) { [rule_set_1, rule_set_2] }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet).to receive(:where)
        .and_return(rule_sets)
      allow(rule_set_1).to receive(:required_for_patient?).and_return(true)
      allow(rule_set_2).to receive(:required_for_patient?).and_return(false)
    end

    it { expect(subject.required_pathology).to eq([rule_set_1.request_description]) }
  end
end
