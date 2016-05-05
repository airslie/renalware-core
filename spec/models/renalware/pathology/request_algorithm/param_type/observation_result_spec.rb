require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:observation_request) { create(:pathology_observation_request, patient: patient) }
  let(:result) { 99 }

  let(:param_comparison_operator) { "<" }
  let(:param_comparison_value) { 100 }
  let(:observation_result) do
    Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult.new(
      patient,
      observation_description.id,
      param_comparison_operator,
      param_comparison_value
    )
  end

  describe "#initialize" do
    let(:param_comparison_operator) { "NOT A VALID OPERATOR" }

    subject { observation_result }

    it { expect{ subject }.to raise_error(ArgumentError) }
  end

  describe "#patient_requires_test?" do
    context "observation_result exists" do
      let!(:observation) do
        create(
          :pathology_observation,
          request: observation_request,
          description: observation_description,
          observed_at: Time.now - 1.week,
          result: result
        )
      end

      context "result is less than 100" do
        subject! { observation_result.patient_requires_test? }

        it { is_expected.to eq(true) }
      end

      context "result is not less than 100" do
        let(:result) { 100 }

        subject! { observation_result.patient_requires_test? }

        it { is_expected.to eq(false) }
      end
    end

    context "observation_result does not exist" do
      let(:observation) { nil }

      subject! { observation_result.patient_requires_test? }

      it { is_expected.to eq(true) }
    end
  end
end
