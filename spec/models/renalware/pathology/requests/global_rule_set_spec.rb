require "rails_helper"

RSpec.shared_examples "a valid request" do
  it "is valid" do
    expect(rule_set.valid?).to be_truthy
  end
end

RSpec.shared_examples "an invalid request" do
  it "is invalid" do
    expect(rule_set.valid?).to be_falsey
  end
end

describe Renalware::Pathology::Requests::GlobalRuleSet do
  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:request_description) do
    create(
      :pathology_request_description,
      required_observation_description: observation_description,
      bottle_type: "serum"
    )
  end

  subject(:rule_set) do
    build(
      :pathology_requests_global_rule_set,
      frequency_type: "Once",
      request_description: request_description
    )
  end

  describe "#valid?" do
    context "a request_description has no required_observation_description" do
      let!(:request_description) { create(:pathology_request_description, bottle_type: "serum") }

      it_behaves_like "an invalid request"
    end

    context "a request_description has no bottle_type" do
      let!(:observation_description) { create(:pathology_observation_description) }
      let!(:request_description) do
        create(
          :pathology_request_description,
          required_observation_description: observation_description
        )
      end

      it_behaves_like "an invalid request"
    end

    context "a request_description has the necessary fields set" do
      let!(:observation_description) { create(:pathology_observation_description) }
      let!(:request_description) do
        create(
          :pathology_request_description,
          required_observation_description: observation_description,
          bottle_type: "serum"
        )
      end

      it_behaves_like "a valid request"
    end
  end
end
