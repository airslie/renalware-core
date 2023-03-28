# frozen_string_literal: true

require "rails_helper"

module Renalware::Drugs
  describe DMDMigration::DrugMigrator do
    let(:dmd_drug) { create(:drug, name: "DMD Drug", code: "ABCD") }
    let(:drug) { create(:drug, code: nil) }
    let(:drug_no_match) { create(:drug, code: nil) }
    let(:prescription) { create(:prescription, drug: drug) }
    let(:prescription_without_a_match) { create(:prescription, drug: drug_no_match) }
    let(:match) { DMDMatch.create!(drug: drug, vtm_name: "DMD Drug", approved_vtm_match: true) }

    before do
      prescription && dmd_drug && prescription_without_a_match && match
    end

    context "when a vmt_drug_name exists in the match table" do
      it "replaces the old drug with the DMD matched drug" do
        described_class.new.call
        expect(prescription.reload.drug_id).to eq dmd_drug.id
        expect(prescription_without_a_match.reload.drug_id).to eq drug_no_match.id

        # Re-run -> shouldn't change anything or report an error
        described_class.new.call
        expect(prescription.reload.drug_id).to eq dmd_drug.id

        # Won't update if approved_vtm_match flag is false
        match.update_column(:approved_vtm_match, false)
        prescription.update_column(:drug_id, drug.id)

        described_class.new.call
        expect(prescription.reload.drug_id).to eq drug.id
      end
    end
  end
end
