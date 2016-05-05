require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRuleSet do
  it { is_expected.to validate_presence_of(:observation_description) }
  it { is_expected.to validate_presence_of(:regime) }
  it do
    is_expected.to validate_inclusion_of(:regime)
      .in_array(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet::REGIMES)
  end
  it do
    is_expected.to validate_inclusion_of(:frequency)
      .in_array(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet::FREQUENCIES)
  end

  let(:frequency) { "Once" }
  let(:rules) { [] }
  let(:global_rule_set) do
    build(
      :pathology_request_algorithm_global_rule_set,
      frequency: frequency,
      observation_description_id: observation_description.id,
      rules: rules
    )
  end

  describe "#required_for_patient?" do
    let!(:patient) { create(:patient) }
    let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }
    let!(:observation_description) { create(:pathology_observation_description) }
    let!(:observation_request) do
      create(:pathology_observation_request, patient: pathology_patient)
    end

    let(:rule_1) { build(:pathology_request_algorithm_global_rule) }
    let(:rule_2) { build(:pathology_request_algorithm_global_rule) }
    let(:rules) { [rule_1, rule_2] }
    let(:rule_1_required) { true }
    let(:rule_2_required) { true }

    before do
      allow(rule_1).to receive(:required_for_patient?).and_return(rule_1_required)
      allow(rule_2).to receive(:required_for_patient?).and_return(rule_2_required)
    end

    context "all rules required" do
      let(:rule_1_required) { true }
      let(:rule_2_required) { true }
      let(:observation_query) { double(Renalware::Pathology::ObservationForPatientQuery) }
      let(:last_observation) { nil }

      before do
        allow(Renalware::Pathology::ObservationForPatientQuery).to receive(:new)
          .and_return(observation_query)
        allow(observation_query).to receive(:call).and_return(last_observation)
      end

      subject { global_rule_set.required_for_patient?(patient) }

      context "last observation is nil" do
        it { is_expected.to eq(true) }
      end

      context "last observation is not nil" do
        let(:last_observation) do
          build(
            :pathology_observation,
            request: observation_request,
            description: observation_description,
            observed_at: Time.now - 1.week
          )
        end

        it { is_expected.to eq(false) }
      end
    end

    context "only one rule required" do
      let(:rule_1_required) { false }
      let(:rule_2_required) { true }

      subject { global_rule_set.required_for_patient?(patient) }

      it { is_expected.to eq(false) }
    end

    context "no rules required" do
      let(:rule_1_required) { false }
      let(:rule_2_required) { false }

      subject { global_rule_set.required_for_patient?(patient) }

      it { is_expected.to eq(false) }
    end
  end
end
