require "rails_helper"

module Renalware::Pathology::RequestAlgorithm::ParamType
  describe Drug do
    let!(:patient) { create(:patient) }
    let!(:drug) { create(:drug) }

    subject(:param_type_drug) { Drug.new(patient, drug.id, "include?", nil) }

    describe "#patient_requires_test?" do
      context "given the patient is currently prescribed the drug" do
        let!(:medication) { create(:medication, patient: patient, drug: drug) }

        subject(:patient_requires_test?) { param_type_drug.patient_requires_test? }

        it { expect(patient_requires_test?).to be_truthy }
      end

      context "given the patient is not currently prescribed the drug" do
        subject(:patient_requires_test?) { param_type_drug.patient_requires_test? }

        it { expect(patient_requires_test?).to be_falsey }
      end
    end
  end
end
