require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRuleSet do
  it { is_expected.to validate_presence_of(:observation_description) }
  it { is_expected.to validate_presence_of(:regime) }
  it { is_expected.to validate_inclusion_of(:regime).in_array(described_class::REGIMES) }
  it { is_expected.to validate_inclusion_of(:frequency).in_array(described_class::FREQUENCIES) }

  let(:frequency) { "Once" }
  let(:global_rule_set) do
    build(
      :pathology_request_algorithm_global_rule_set,
      frequency: frequency,
      observation_description_id: observation_description.id
    )
  end

  describe "#required_for_patient?" do
    let!(:patient) { create(:patient) }
    let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }
    let!(:observation_description) { create(:pathology_observation_description) }
    let!(:observation_request) do
      create(:pathology_observation_request, patient: pathology_patient)
    end

    subject { global_rule_set.required_for_patient?(patient) }

    context "frequency = 'Once'" do
      context "last_observation is nil" do
        let(:last_observation) { nil }

        it { is_expected.to eq(true) }
      end

      context "last_observation is not nil" do
        let!(:last_observation) do
          create(
            :pathology_observation,
            request: observation_request,
            description: observation_description
          )
        end

        it { is_expected.to eq(false) }
      end
    end
  end
end
