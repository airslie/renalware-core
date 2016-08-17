require "rails_helper"

describe Renalware::Pathology::Requests::GlobalRuleSet do
  let(:clinic) { build(:clinic) }
  let(:observation_description) { build(:pathology_observation_description) }
  let(:request_description) do
    build(
      :pathology_request_description,
      required_observation_description: observation_description,
      bottle_type: "serum"
    )
  end

  subject(:global_rule_set) do
    build(
      :pathology_requests_global_rule_set,
      clinic: clinic,
      frequency_type: "Once",
      request_description: request_description
    )
  end

  describe "#valid?" do
    context "no request_description is given" do
      let(:request_description) { nil }

      it { expect(global_rule_set).to be_invalid }
    end

    context "given a request_description" do
      context "without a required_observation_description" do
        let(:request_description) { build(:pathology_request_description, bottle_type: "serum") }

        it { expect(global_rule_set).to be_invalid }
      end

      context "without a bottle_type" do
        let(:observation_description) { build(:pathology_observation_description) }
        let(:request_description) do
          build(
            :pathology_request_description,
            required_observation_description: observation_description
          )
        end

        it { expect(global_rule_set).to be_invalid }
      end

      context "with the necessary fields set" do
        let(:observation_description) { build(:pathology_observation_description) }
        let(:request_description) do
          build(
            :pathology_request_description,
            required_observation_description: observation_description,
            bottle_type: "serum"
          )
        end

        it { expect(global_rule_set).to be_valid }
      end
    end
  end
end
