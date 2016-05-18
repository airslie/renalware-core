require "rails_helper"

describe Renalware::Pathology::Patient do
  subject(:patient) { Renalware::Pathology.cast_patient(build(:patient)) }

  describe "#required_observation_requests" do
    let(:algorithm) { double(Renalware::Pathology::RequestAlgorithm::Global) }
    let(:request_descriptions) { double }
    let(:clinic) { build(:clinic) }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::Global).to receive(:new).and_return(algorithm)
      allow(algorithm).to receive(:determine_required_request_descriptions)
        .and_return(request_descriptions)
    end

    subject(:required_request_descriptions) { patient.required_observation_requests(clinic) }

    it { expect(required_request_descriptions).to eq(request_descriptions) }
  end

  describe "#required_patient_pathology" do
    let(:algorithm) { double(Renalware::Pathology::RequestAlgorithm::Patient) }
    let(:test_descriptions) { double }
    let(:clinic) { build(:clinic) }

    before do
      allow(Renalware::Pathology::RequestAlgorithm::Patient).to receive(:new).and_return(algorithm)
      allow(algorithm).to receive(:determine_required_tests).and_return(test_descriptions)
    end

    subject(:required_test_descriptions) { patient.required_patient_pathology }

    it { expect(required_test_descriptions).to eq(test_descriptions) }
  end
end
