require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:observation_request) { create(:pathology_observation_request, patient: patient) }
  let!(:observation) do
    create(
      :pathology_observation,
      request: observation_request,
      description: observation_description,
      observed_at: Time.now - 1.week
    )
  end

  let(:param_comparison_operator) { '<' }
  let(:param_comparison_value) { 100 }
  let(:observation_result) do
    described_class.new(
      patient,
      observation_description.id,
      param_comparison_operator,
      param_comparison_value
    )
  end

  describe '#initialize' do
    let(:param_comparison_operator) { 'NOT A VALID OPERATOR' }

    subject { observation_result }

    it { expect{ subject }.to raise_error(ArgumentError) }
  end

  describe "#patient_requires_test?" do
    let(:patient_requires_test) { double }

    before do
      allow(observation_result).to receive(:observation_result).and_return(observation)
      allow(observation).to receive(:send).and_return(patient_requires_test)
    end

    subject! { observation_result.patient_requires_test? }

    it { expect(observation_result).to have_received(:observation_result) }
    it do
      expect(observation).to have_received(:send)
        .with(param_comparison_operator.to_sym, param_comparison_value)
    end
    it { is_expected.to eq(patient_requires_test) }
  end

  describe "#observation_result" do
    subject { observation_result.send(:observation_result) }

    it { is_expected.to eq(observation.result.to_i) }
  end
end
