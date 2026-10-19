module Renalware::Drugs
  describe DMDMigration::MatchImport do
    let(:drug) { create(:drug, name: "Legacy tablets") }
    let!(:match) { DMDMatch.create!(drug:, drug_name: drug.name) }
    let!(:target) { create(:drug, name: "Target", code: "123") }
    let(:headers) { described_class::HEADERS + %w(drug_id form_name) }
    let(:row) { [drug.name, target.name, "TRUE", nil, "FALSE", "999999", nil] }

    def importer(rows = [row], validate_only: false)
      csv = CSV.generate do |output|
        output << headers
        rows.each { |values| output << values }
      end
      described_class.new(file: StringIO.new(csv), validate_only:)
    end

    it "imports by name ignoring foreign IDs without modifying prescriptions" do
      prescription = create(:prescription, drug:)
      original = prescription.reload.attributes
      brand = create(:drug_trade_family, name: "Brand")
      form = create(:drug_form, name: "Tablet")
      row[3..4] = [brand.name, "t"]
      row[6] = form.name

      import = importer
      expect(import.save).to be(true), import.errors.full_messages.join("; ")
      expect(match.reload).to have_attributes(
        drug_id: drug.id, vtm_name: target.name, approved_vtm_match: true,
        trade_family_name: brand.name, approved_trade_family_match: true, form_name: form.name
      )
      expect(prescription.reload.attributes).to eq(original)
    end

    it "validates without saving" do
      original = match.attributes
      import = importer(validate_only: true)
      expect(import.save).to be(true)
      expect(import.imported_count).to eq(1)
      expect(match.reload.attributes).to eq(original)
    end

    it "rejects the entire file if a later source name is unknown" do
      import = importer([row, row.dup.tap { |values| values[0] = "Unknown" }])
      expect(import.save).to be(false)
      expect(import.errors.full_messages.join).to include("Row 3", "exactly one local mapping")
      expect(match.reload.approved_vtm_match).to be(false)
    end

    it "rejects a file that is not an upload" do
      import = described_class.new(file: "not a file", validate_only: false)
      expect(import.save).to be(false)
      expect(import.errors[:file]).to include("is invalid")
    end

    it "rejects files that are not valid UTF-8" do
      import = described_class.new(file: StringIO.new("drug_name\n\xFF".b), validate_only: false)
      expect(import.save).to be(false)
      expect(import.errors.full_messages.join).to include("UTF-8")
    end

    it "does not report unrelated argument errors as CSV problems" do
      allow(DMDMatch).to receive(:where).and_raise(ArgumentError, "boom")
      expect { importer.save }.to raise_error(ArgumentError, "boom")
    end

    it "rejects duplicate CSV names" do
      import = importer([row, row])
      expect(import.save).to be(false)
      expect(import.errors.full_messages.join).to include("duplicate drug name")
    end

    it "rejects ambiguous local names" do
      DMDMatch.create!(drug: create(:drug, name: drug.name), drug_name: drug.name)
      expect(importer.save).to be(false)
    end

    it "rejects stale source IDs" do
      match.update!(drug: target)
      expect(importer.save).to be(false)
    end

    it "rejects missing, inactive, soft-deleted and ambiguous approved targets" do
      target.update!(inactive: true)
      expect(importer.save).to be(false)
      target.update!(inactive: false, deleted_at: Time.current)
      expect(importer.save).to be(false)
      target.update!(deleted_at: nil)
      create(:drug, name: target.name, code: "456")
      expect(importer.save).to be(false)
      row[1] = "Unknown"
      expect(importer.save).to be(false)
    end

    it "rejects unknown approved trade families and forms" do
      row[3..4] = %w(Unknown TRUE)
      row[6] = "Unknown"
      import = importer
      expect(import.save).to be(false)
      expect(import.errors.full_messages.join).to include("trade_family_name", "form_name")
    end

    it "clears previous approvals and forms when explicitly supplied as false or blank" do
      match.update!(approved_vtm_match: true, approved_trade_family_match: true,
                    form_name: "Tablet")
      row[2] = "false"
      row[4] = nil
      expect(importer.save).to be(true)
      expect(match.reload).to have_attributes(
        approved_vtm_match: false, approved_trade_family_match: false, form_name: nil
      )
    end

    it "preserves forms when the form column is omitted" do
      match.update!(form_name: "Tablet")
      headers.pop
      row.pop
      expect(importer.save).to be(true)
      expect(match.reload.form_name).to eq("Tablet")
    end

    it "rejects invalid approval values" do
      row[2] = "yes"
      expect(importer.save).to be(false)
    end

    it "does not infer VTM approval from an approved brand" do
      brand = create(:drug_trade_family, name: "Brand")
      row[1..4] = [nil, "FALSE", brand.name, "TRUE"]
      expect(importer.save).to be(true)
      expect(match.reload).to have_attributes(vtm_name: nil, approved_vtm_match: false,
                                              approved_trade_family_match: true)
    end

    it "accepts UTF-8 CSV with a byte order mark" do
      csv = "\uFEFF#{CSV.generate_line(headers)}#{CSV.generate_line(row)}"
      import = described_class.new(file: StringIO.new(csv.b), validate_only: false)
      expect(import.save).to be(true)
    end

    it "rejects duplicate headings and invalid UTF-8" do
      headers << "drug_name"
      expect(importer.save).to be(false)
      import = described_class.new(file: StringIO.new("\xFF".b))
      expect(import.save).to be(false)
    end

    it "rejects missing files, missing headers, empty files and malformed CSV" do
      expect(described_class.new.save).to be(false)
      ["", "drug_name\nLegacy\n", '"unterminated'].each do |csv|
        expect(described_class.new(file: StringIO.new(csv)).save).to be(false)
      end
    end
  end
end
