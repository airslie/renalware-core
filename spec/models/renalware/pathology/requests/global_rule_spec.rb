require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRule do
  it { is_expected.to validate_presence_of(:global_rule_set) }
  it do
    is_expected.to validate_inclusion_of(:param_comparison_operator)
      .in_array(Renalware::Pathology::Requests::GlobalRule::PARAM_COMPARISON_OPERATORS)
  end

  let!(:clinic) { create(:clinic) }
  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:request_description) do
    create(
      :pathology_request_description,
      required_observation_description: observation_description,
      bottle_type: "serum"
    )
  end

  let(:rule_set) do
    build(
      :pathology_requests_global_rule_set,
      clinic: clinic,
      frequency_type: "Once",
      request_description: request_description
    )
  end

  subject(:rule) do
    create(:pathology_requests_global_rule, param_type: "Fake", global_rule_set: rule_set)
  end

  describe "#required_for_patient?" do
    let(:patient) { create(:patient) }

    subject(:rule_required?) { rule.required_for_patient?(patient) }

    it { expect(rule_required?).to be_truthy }
  end
end

class Renalware::Pathology::Requests::ParamType::Fake
  def initialize(*_args); end

  def required?
    true
  end
end
