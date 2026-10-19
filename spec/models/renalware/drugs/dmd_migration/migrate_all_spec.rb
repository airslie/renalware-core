module Renalware::Drugs
  describe DMDMigration::MigrateAll do
    let(:legacy_drug) { create(:drug, name: "Legacy drug", code: nil) }
    let(:dmd_drug) { create(:drug, name: "DMD drug", code: "123") }
    let(:trade_family) { create(:drug_trade_family, name: "Brand") }
    let(:form) { create(:drug_form, name: "Tablet") }
    let!(:prescription) { create(:prescription, drug: legacy_drug, form: nil, trade_family: nil) }
    let!(:match) do
      DMDMatch.create!(drug: legacy_drug, drug_name: legacy_drug.name,
                       trade_family_name: trade_family.name, approved_trade_family_match: true,
                       form_name: form.name, vtm_name: nil, approved_vtm_match: false)
    end

    before do
      create(:drug_vmp_classification, drug: dmd_drug, trade_family_ids: [trade_family.id])
    end

    it "infers the VTM and migrates the form, brand and drug while preserving the legacy drug" do
      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: dmd_drug.name, approved_vtm_match: true)
      expect(prescription.reload).to have_attributes(
        drug_id: dmd_drug.id, legacy_drug_id: legacy_drug.id,
        trade_family_id: trade_family.id, form_id: form.id
      )

      original = prescription.attributes
      described_class.new.call
      expect(prescription.reload.attributes).to eq(original)
    end

    it "leaves the legacy drug unchanged when the trade family resolves to multiple VTMs" do
      other_drug = create(:drug, name: "Other DMD drug", code: "456")
      create(:drug_vmp_classification, drug: other_drug, trade_family_ids: [trade_family.id])

      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: nil, approved_vtm_match: false)
      expect(prescription.reload).to have_attributes(drug_id: legacy_drug.id, legacy_drug_id: nil)
    end
  end
end
