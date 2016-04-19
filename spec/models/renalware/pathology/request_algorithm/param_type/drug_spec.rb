require "rails_helper"

describe Renalware::Pathology::RequestAlgorithm::ParamType::Drug do
  let!(:patient) { create(:patient) }
  let!(:drug) { create(:drug) }
  let!(:medication) { create(:medication, patient: patient, drug: drug) }

  let(:param_type) do
    described_class.new(
      patient,
      drug.id,
      "include?",
      nil
    )
  end

  describe "#patient_requires_test?" do
    subject { param_type.patient_requires_test? }

    it { is_expected.to eq(true) }
  end
end
