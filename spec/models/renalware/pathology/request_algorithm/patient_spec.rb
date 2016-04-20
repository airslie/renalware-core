require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::Patient do
  let(:patient) { create(:patient) }
  let(:pathology_patient) { Renalware::Pathology.cast_patient(patient) }

  let(:patient_rule_1) { create(:pathology_request_algorithm_patient_rule, patient: pathology_patient) }
  let(:patient_rule_2) { create(:pathology_request_algorithm_patient_rule, patient: pathology_patient) }
  let(:patient_rules) { [patient_rule_1, patient_rule_2] }
  let(:patient_algorithm) { described_class.new(patient) }

  describe '#required_pathology' do
    before do
      allow(Renalware::Pathology).to receive(:cast_patient).and_return(pathology_patient)
      allow(pathology_patient).to receive(:patient_rules).and_return(patient_rules)
      allow(patient_rule_1).to receive(:required?).and_return(true)
      allow(patient_rule_2).to receive(:required?).and_return(false)
    end

    subject { patient_algorithm.required_pathology }

    it { is_expected.to eq([patient_rule_1]) }
  end
end
