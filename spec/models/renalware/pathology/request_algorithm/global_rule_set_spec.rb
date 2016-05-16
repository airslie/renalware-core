require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::GlobalRuleSet do
  it { is_expected.to validate_presence_of(:request_description) }
  it { is_expected.to validate_presence_of(:clinic) }
  it do
    is_expected.to validate_inclusion_of(:frequency)
      .in_array(Renalware::Pathology::RequestAlgorithm::GlobalRuleSet::FREQUENCIES)
  end

  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:request_description) do
    create(
      :pathology_request_description,
      required_observation_description: observation_description
    )
  end

  subject(:rule_set) do
    build(
      :pathology_request_algorithm_global_rule_set,
      frequency: "Once",
      request_description: request_description
    )
  end

  describe "#required_for_patient?" do
    let!(:patient) { create(:patient) }
    let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }
    let!(:observation_request) do
      create(:pathology_observation_request, patient: pathology_patient)
    end
    let(:rule_1) { build(:pathology_request_algorithm_global_rule) }
    let(:rule_2) { build(:pathology_request_algorithm_global_rule) }

    subject(:rule_set_required?) { rule_set.required_for_patient?(pathology_patient) }

    context "given all the rules from the rule_set are required" do
      let(:observation_query) do
        double(Renalware::Pathology::ObservationForPatientRequestDescriptionQuery)
      end

      before do
        allow(rule_set).to receive(:rules).and_return([rule_1, rule_2])
        allow(rule_1).to receive(:required_for_patient?).and_return(true)
        allow(rule_2).to receive(:required_for_patient?).and_return(true)
        allow(Renalware::Pathology::ObservationForPatientRequestDescriptionQuery).to receive(:new)
          .and_return(observation_query)
      end

      context "given last observation for this patient is nil" do
        before { allow(observation_query).to receive(:call).and_return(nil) }

        it { expect(rule_set_required?).to be_truthy }
      end

      context "given last observation for this patient is not nil" do
        let(:last_observation) do
          build(
            :pathology_observation,
            request: observation_request,
            description: observation_description,
          )
        end

        before { allow(observation_query).to receive(:call).and_return(last_observation) }

        it { expect(rule_set_required?).to be_falsey }
      end
    end

    context "given only one of the rules from the rule_set is required" do
      before do
        allow(rule_set).to receive(:rules).and_return([rule_1, rule_2])
        allow(rule_1).to receive(:required_for_patient?).and_return(false)
        allow(rule_2).to receive(:required_for_patient?).and_return(true)
      end

      it { expect(rule_set_required?).to be_falsey }
    end

    context "given no rules from the rule_set are required" do
      before do
        allow(rule_set).to receive(:rules).and_return([rule_1, rule_2])
        allow(rule_1).to receive(:required_for_patient?).and_return(false)
        allow(rule_2).to receive(:required_for_patient?).and_return(false)
      end

      it { expect(rule_set_required?).to be_falsey }
    end
  end
end
