require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:observation_description) { create(:pathology_observation_description) }
  let!(:observation_request) { create(:pathology_observation_request, patient: patient) }
  let(:result) { 99 }

  let(:param_comparison_operator) { "<" }
  let(:param_comparison_value) { 100 }
  subject do
    Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult.new(
      patient,
      observation_description.id,
      param_comparison_operator,
      param_comparison_value
    )
  end

  describe "#initialize" do
    let(:param_comparison_operator) { "NOT A VALID OPERATOR" }

    it { expect{ subject }.to raise_error(ArgumentError) }
  end

  describe "#patient_requires_test?" do
    context "observation exists" do
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
        it { expect(subject.patient_requires_test?).to eq(true) }
      end

      context "result is not less than 100" do
        let(:result) { 100 }

        it { expect(subject.patient_requires_test?).to eq(false) }
      end
    end

    context "observation does not exist" do
      let(:observation) { nil }

      it { expect(subject.patient_requires_test?).to eq(true) }
    end
  end
end
