require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRule do
  it { is_expected.to be_an ActiveRecord::Base }

  it { is_expected.to validate_presence_of(:observation_description_id) }
  it { is_expected.to validate_presence_of(:regime) }
  it do
    is_expected.to validate_inclusion_of(:regime)
      .in_array(described_class::REGIMES)
  end
  it do
    is_expected.to validate_inclusion_of(:param_comparison_operator)
      .in_array(described_class::PARAM_COMPARISON_OPERATORS)
  end

  describe "#has_param?" do
    let(:global_rule) { create(:pathology_request_algorithm_global_rule) }

    subject { global_rule.has_param? }

    it { is_expected.to eq(true) }
  end
end
