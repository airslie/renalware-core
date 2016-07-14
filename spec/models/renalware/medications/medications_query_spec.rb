require "rails_helper"

module Renalware::Medications
  RSpec.describe MedicationsQuery, type: :model do

    let(:patient) { create(:patient) }

    context "given no filter" do
      let!(:current_medication) do
        create(:medication, notes: ":current:", patient: patient, treatable: patient)
      end

      subject(:query) { MedicationsQuery.new(relation: patient.medications) }

      it "returns medications for a treatable target" do
        medications = query.call

        expect(medications.map(&:notes)).to include(current_medication.notes)
      end
    end

    context "given a filter for a drug type" do
      let(:target_drug_type) { create(:drug_type) }
      let(:target_drug) { create(:drug, drug_types: [target_drug_type]) }
      let!(:target_medication) do
        create(
          :medication, notes: ":target:",
          patient: patient, treatable: patient, drug: target_drug
        )
      end

      let(:other_drug_type) { create(:drug_type) }
      let(:other_drug)  { create(:drug, drug_types: [other_drug_type]) }
      let!(:other_medication) do
        create(
          :medication, notes: ":other:",
          patient: patient, treatable: patient, drug: other_drug
        )
      end

      subject(:query) do
        MedicationsQuery.new(
          relation: patient.medications,
          search_params: { drug_drug_types_id_eq: target_drug_type.id }
        )
      end

      it "returns the current medications matching the specified drug type only" do
        medications = query.call

        expect(medications.map(&:notes)).to include(target_medication.notes)
        expect(medications.map(&:notes)).not_to include(other_medication.notes)
      end
    end
  end
end
