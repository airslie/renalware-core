require "rails_helper"

RSpec::Matchers.define :be_required? do |expected|
  match do |actual|
    actual.patient_requires_test? == expected
  end
end

describe Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult do
  let!(:patient) { Renalware::Pathology.cast_patient(create(:patient)) }
  let!(:observation_description) { create(:pathology_observation_description) }

  describe "#initialize" do
    context "given the operator is invalid" do
      subject(:param_type) do
        Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult.new(
          patient,
          observation_description.id,
          "NOT A VALID OPERATOR",
          100
        )
      end

      it { expect{ param_type }.to raise_error(ArgumentError) }
    end
  end

  describe "#patient_requires_test?" do
    let!(:observation_request) { create(:pathology_observation_request, patient: patient) }

    subject(:param_type) do
      Renalware::Pathology::RequestAlgorithm::ParamType::ObservationResult.new(
        patient,
        observation_description.id,
        "<",
        100
      )
    end

    context "given the observation exists for the patient" do
      let!(:observation) do
        create(
          :pathology_observation,
          request: observation_request,
          description: observation_description,
          result: result
        )
      end

      context "given the patient's observation result is less than 100" do
        let(:result) { 99 }

        it { expect(param_type).to be_required?(true) }
      end

      context "given the patient's observation result is more than or equal to 100" do
        let(:result) { 100 }

        it { expect(param_type).to be_required?(false) }
      end
    end

    context "given the observation does not exist for the patient" do
      it { expect(param_type).to be_required?(true) }
    end
  end
end
