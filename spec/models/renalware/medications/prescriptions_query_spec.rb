require "rails_helper"

module Renalware::Medications
  RSpec.describe PrescriptionsQuery, type: :model do

    let(:patient) { create(:patient) }

    context "given no filter" do
      let!(:current_prescription) do
        create(:prescription, notes: ":current:", patient: patient, treatable: patient)
      end

      subject(:query) { PrescriptionsQuery.new(relation: patient.prescriptions) }

      it "returns prescriptions for a treatable target" do
        prescriptions = query.call

        expect(prescriptions.map(&:notes)).to include(current_prescription.notes)
      end
    end

    context "given a filter for a drug type" do
      let(:target_drug_type) { create(:drug_type) }
      let(:target_drug) { create(:drug, drug_types: [target_drug_type]) }
      let!(:target_prescription) do
        create(
          :prescription, notes: ":target:",
          patient: patient, treatable: patient, drug: target_drug
        )
      end

      let(:other_drug_type) { create(:drug_type) }
      let(:other_drug) { create(:drug, drug_types: [other_drug_type]) }
      let!(:other_prescription) do
        create(
          :prescription, notes: ":other:",
          patient: patient, treatable: patient, drug: other_drug
        )
      end

      subject(:query) do
        PrescriptionsQuery.new(
          relation: patient.prescriptions,
          search_params: { drug_drug_types_id_eq: target_drug_type.id }
        )
      end

      it "returns the current prescriptions matching the specified drug type only" do
        prescriptions = query.call

        expect(prescriptions.map(&:notes)).to include(target_prescription.notes)
        expect(prescriptions.map(&:notes)).not_to include(other_prescription.notes)
      end
    end
  end
end
