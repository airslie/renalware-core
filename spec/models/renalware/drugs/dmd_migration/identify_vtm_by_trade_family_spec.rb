module Renalware::Drugs
  describe DMDMigration::IdentifyVtmByTradeFamily do
    let(:dmd_drug) { create(:drug, name: "DMD Drug", code: "ABCD") }
    let(:legacy_drug) { create(:drug, code: nil, name: "Legacy Drug") }
    let(:trade_family) { create(:drug_trade_family, name: "Trade Family Name") }
    let(:vmp_classification) {
      create(
        :drug_vmp_classification,
        drug: dmd_drug,
        trade_family_ids: [trade_family.id]
      )
    }
    let(:match) {
      DMDMatch.create!(
        drug: legacy_drug,
        trade_family_name: "Trade Family Name",
        approved_trade_family_match: true,
        vtm_name: nil,
        approved_vtm_match: false
      )
    }

    before do
      dmd_drug && vmp_classification && match
    end

    context "when trade family is approved in a DMD Match, " \
            "but the vtm is not found" do
      it "then identify the vtm name using a classification" do
        described_class.new.call

        match.reload
        expect(match.vtm_name).to eq "DMD Drug"
        expect(match.approved_vtm_match).to be true
      end
    end

    it "infers a VTM when several classifications refer to the same drug" do
      create(:drug_vmp_classification, drug: dmd_drug, trade_family_ids: [trade_family.id])

      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: dmd_drug.name, approved_vtm_match: true)
    end

    it "does not infer a VTM when classifications refer to different drugs" do
      other_drug = create(:drug, name: dmd_drug.name, code: "OTHER")
      create(:drug_vmp_classification, drug: other_drug, trade_family_ids: [trade_family.id])

      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: nil, approved_vtm_match: false)
    end

    it "does not infer a VTM from an unapproved trade family" do
      match.update!(approved_trade_family_match: false)

      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: nil, approved_vtm_match: false)
    end

    it "does not overwrite or approve an existing VTM suggestion" do
      match.update!(vtm_name: "Existing suggestion")

      described_class.new.call

      expect(match.reload).to have_attributes(
        vtm_name: "Existing suggestion", approved_vtm_match: false
      )
    end

    it "does not infer a VTM when the trade family is unknown" do
      match.update!(trade_family_name: "Unknown")

      described_class.new.call

      expect(match.reload).to have_attributes(vtm_name: nil, approved_vtm_match: false)
    end

    context "when classification is not found" do
      before do
        vmp_classification.update(trade_family_ids: [0])
      end

      it "does nothing" do
        described_class.new.call

        match.reload
        expect(match.vtm_name).to be_nil
        expect(match.approved_vtm_match).to be false
      end
    end
  end
end
