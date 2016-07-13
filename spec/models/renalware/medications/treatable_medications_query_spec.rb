require "rails_helper"

module Renalware::Medications
  RSpec.describe TreatableMedicationsQuery, type: :model do

    let(:treatable) { create(:patient) }

    context "given no filter" do
      let!(:current_medication) { create(:medication, patient: treatable, treatable: treatable) }
      let!(:terminated_medication) do create(
        :medication, :terminated,
        patient: treatable, treatable: treatable
      )
      end

      subject(:query) { TreatableMedicationsQuery.new(treatable: treatable) }

      it "returns current medications for a treatable target" do
        medications = query.call

        expect(medications).to include(current_medication)
        expect(medications).not_to include(terminated_medication)
      end
    end

    context "given a filter for a drug type" do
      let(:target_drug_type) { create(:drug_type) }
      let(:target_drug) { create(:drug, drug_types: [target_drug_type]) }
      let!(:target_medication) do
        create(
          :medication, notes: ":target medication:",
          patient: treatable, treatable: treatable, drug: target_drug
        )
      end

      let(:other_drug_type) { create(:drug_type) }
      let(:other_drug)  { create(:drug, drug_types: [other_drug_type]) }
      let!(:other_medication) do
        create(
          :medication, notes: ":other medication:",
          patient: treatable, treatable: treatable, drug: other_drug
        )
      end

      subject(:query) do
        TreatableMedicationsQuery.new(
          treatable: treatable,
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
