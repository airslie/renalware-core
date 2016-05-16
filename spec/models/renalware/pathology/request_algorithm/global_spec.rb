require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Global do
  let(:patient) { build(:patient) }
  let(:clinic) { build(:clinic) }

  subject(:global_algorithm) do
    Renalware::Pathology::RequestAlgorithm::Global.new(patient, clinic)
  end

  describe "#determine_required_request_descriptions" do
    let(:required_rule_set) { build(:pathology_request_algorithm_global_rule_set) }
    let(:not_required_rule_set) { build(:pathology_request_algorithm_global_rule_set) }
    let(:rule_sets) { [required_rule_set, not_required_rule_set] }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet).to receive(:where)
        .and_return(rule_sets)
      allow(required_rule_set).to receive(:required_for_patient?).and_return(true)
      allow(not_required_rule_set).to receive(:required_for_patient?).and_return(false)
    end

    subject(:required_request_descriptions) do
      global_algorithm.determine_required_request_descriptions
    end

    it "returns the request descriptions for the required rule_sets" do
      expect(required_request_descriptions).to eq([required_rule_set.request_description])
    end
  end
end
