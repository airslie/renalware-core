require "rails_helper"

module Renalware::Pathology::RequestAlgorithm::ParamType
  describe Drug do
    let!(:patient) { create(:patient) }
    let!(:drug) { create(:drug) }

    subject(:param_type) { Drug.new(patient, drug.id, "include?", nil) }

    describe "#required?" do
      context "given the patient is currently prescribed the drug" do
        let!(:medication) { create(:medication, patient: patient, drug: drug) }

        it { expect(param_type).to be_required }
      end

      context "given the patient is not currently prescribed the drug" do
        it { expect(param_type).not_to be_required }
      end
    end
  end
end
