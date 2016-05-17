require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Patient do
  let(:patient) { build(:patient) }
  let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }

  let(:required_rule) do
    build(:pathology_request_algorithm_patient_rule, patient: pathology_patient)
  end
  let(:not_required_rule) do
    build(:pathology_request_algorithm_patient_rule, patient: pathology_patient)
  end
  let(:rules) { [required_rule, not_required_rule] }

  subject(:patient_algorithm) do
    Renalware::Pathology::RequestAlgorithm::Patient.new(pathology_patient)
  end

  describe "#determine_required_tests" do
    before do
      allow(Renalware::Pathology).to receive(:cast_patient).and_return(pathology_patient)
      allow(pathology_patient).to receive(:rules).and_return(rules)
      allow(required_rule).to receive(:required?).and_return(true)
      allow(not_required_rule).to receive(:required?).and_return(false)
    end

    subject(:required_tests) { patient_algorithm.determine_required_tests }

    it "returns the required rules" do
      expect(required_tests).to eq([required_rule])
    end
  end
end
