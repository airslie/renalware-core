require "csv"

describe "DMD match exports" do
  let(:drug) { create(:drug, name: 'Legacy, "tablets" é') }
  let!(:match) do
    Renalware::Drugs::DMDMatch.create!(
      drug:, drug_name: drug.name, prescriptions_count: 123,
      vtm_name: "Target", approved_vtm_match: false, approved_trade_family_match: nil
    )
  end

  before do
    login_as(create(:user, role: :devops))
    allow(Renalware.config).to receive(:enable_dmd_match).and_return(true)
  end

  it "links to the filtered export without retaining pagination" do
    get drugs_dmd_matches_path, params: { q: { drug_name_cont: "Legacy", s: "drug_name desc" } }
    link = response.parsed_body.css("a").find { |anchor| anchor.text == "Export CSV" }
    expect(link).to be_present
    get link["href"]
    expect(response.media_type).to eq("text/csv")
    expect(CSV.parse(response.body, headers: true).pluck("drug_name")).to eq([drug.name])
  end

  it "exports all filtered rows in the requested order regardless of the requested page" do
    other_drug = create(:drug, name: "Legacy B")
    Renalware::Drugs::DMDMatch.create!(drug: other_drug, drug_name: other_drug.name,
                                       prescriptions_count: 456)
    excluded = create(:drug, name: "Excluded")
    Renalware::Drugs::DMDMatch.create!(drug: excluded, drug_name: excluded.name)

    get drugs_dmd_matches_path(format: :csv), params: {
      page: 2, limit: 1, q: { drug_name_cont: "Legacy", s: "prescriptions_count desc" }
    }

    expect(response).to be_successful
    expect(response.headers["Content-Disposition"]).to include("attachment", "dmd-matches-")
    rows = CSV.parse(response.body, headers: true)
    expect(rows.pluck("drug_name")).to eq([other_drug.name, drug.name])
    expect(rows[1].to_h).to eq(
      "drug_id" => drug.id.to_s, "drug_name" => drug.name, "prescriptions_count" => "123",
      "vtm_name" => "Target", "approved_vtm_match" => "FALSE", "trade_family_name" => nil,
      "approved_trade_family_match" => "FALSE", "form_name" => nil
    )
  end

  it "can import a clinician's completed export without modifying prescriptions" do
    target = create(:drug, name: "Target", code: "123")
    brand = create(:drug_trade_family, name: "Brand")
    form = create(:drug_form, name: "Tablet")
    prescription = create(:prescription, drug:)
    original = prescription.reload.attributes
    get drugs_dmd_matches_path(format: :csv)
    rows = CSV.parse(response.body, headers: true)
    rows[0]["approved_vtm_match"] = "TRUE"
    rows[0]["trade_family_name"] = brand.name
    rows[0]["approved_trade_family_match"] = "TRUE"
    rows[0]["form_name"] = form.name

    import = Renalware::Drugs::DMDMigration::MatchImport.new(
      file: StringIO.new(rows.to_csv), validate_only: false
    )
    expect(import.save).to be(true), import.errors.full_messages.join("; ")
    expect(match.reload).to have_attributes(
      vtm_name: target.name, approved_vtm_match: true, trade_family_name: brand.name,
      approved_trade_family_match: true, form_name: form.name
    )
    expect(prescription.reload.attributes).to eq(original)

    get drugs_dmd_matches_path(format: :csv)
    approved = CSV.parse(response.body, headers: true).first
    expect(approved["approved_vtm_match"]).to eq("TRUE")
    expect(approved["approved_trade_family_match"]).to eq("TRUE")
  end

  it "exports headings when no rows match" do
    get drugs_dmd_matches_path(format: :csv), params: { q: { drug_name_cont: "Missing" } }
    rows = CSV.parse(response.body, headers: true)
    expect(rows).to be_empty
    expect(rows.headers).to include(*Renalware::Drugs::DMDMigration::MatchImport::HEADERS)
  end

  it "denies exports when disabled" do
    allow(Renalware.config).to receive(:enable_dmd_match).and_return(false)
    get drugs_dmd_matches_path(format: :csv)
    expect(response).to redirect_to(dashboard_path)
  end

  it "denies exports to non-devops users" do
    login_as_super_admin
    get drugs_dmd_matches_path(format: :csv)
    expect(response).to redirect_to(dashboard_path)
  end
end
