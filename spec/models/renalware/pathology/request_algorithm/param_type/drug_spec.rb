require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::ParamType::Drug do
  let!(:patient) { create(:patient) }
  let!(:drug) { create(:drug) }
  let!(:medication) { create(:medication, patient: patient, drug: drug) }

  subject do
    Renalware::Pathology::RequestAlgorithm::ParamType::Drug.new(
      patient,
      drug.id,
      "include?",
      nil
    )
  end

  describe "#patient_requires_test?" do
    it { expect(subject.patient_requires_test?).to eq(true) }
  end
end
