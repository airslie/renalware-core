require "tempfile"

describe "DMD match imports" do
  let(:drug) { create(:drug, name: "Legacy") }
  let!(:match) { Renalware::Drugs::DMDMatch.create!(drug:, drug_name: drug.name) }
  let!(:target) { create(:drug, name: "Target", code: "123") }

  before do
    login_as(create(:user, role: :devops))
    allow(Renalware.config).to receive(:enable_dmd_match).and_return(true)
  end

  def upload(validate_only: "0", name: drug.name)
    Tempfile.create(["matches", ".csv"]) do |file|
      file.write(CSV.generate do |csv|
        csv << Renalware::Drugs::DMDMigration::MatchImport::HEADERS
        csv << [name, target.name, "TRUE", nil, "FALSE"]
      end)
      file.flush
      post drugs_dmd_matches_path, params: {
        drugs_dmd_migration_match_import: {
          file: Rack::Test::UploadedFile.new(file.path, "text/csv"), validate_only:
        }
      }
    end
  end

  it "shows an import-only form with validation selected by default" do
    get new_drugs_dmd_match_path
    expect(response).to be_successful
    expect(response.body).to include("It does not change prescriptions")
    expect(response.parsed_body.at_css('input[type="checkbox"]')["checked"]).to be_present
  end

  it "rejects a file param that is not an upload" do
    post drugs_dmd_matches_path, params: {
      drugs_dmd_migration_match_import: { file: "not a file", validate_only: "0" }
    }
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("is invalid")
  end

  it "imports mappings without changing prescriptions" do
    prescription = create(:prescription, drug:)
    original = prescription.reload.attributes
    upload
    expect(response).to redirect_to(drugs_dmd_matches_path)
    expect(match.reload.approved_vtm_match).to be(true)
    expect(prescription.reload.attributes).to eq(original)
    follow_redirect!
    expect(response).to be_successful
    expect(response.body).to include("Imported 1 mappings. Prescriptions are unchanged.")
  end

  it "validates without saving" do
    upload(validate_only: "1")
    expect(response).to redirect_to(drugs_dmd_matches_path)
    expect(match.reload.approved_vtm_match).to be(false)
  end

  it "renders actionable errors without importing" do
    upload(name: "Unknown")
    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("exactly one local mapping")
    expect(match.reload.approved_vtm_match).to be(false)
  end

  it "handles a missing file" do
    post drugs_dmd_matches_path
    expect(response).to have_http_status(:unprocessable_content)
  end

  it "denies imports when the feature is disabled" do
    allow(Renalware.config).to receive(:enable_dmd_match).and_return(false)
    upload
    expect(response).to redirect_to(dashboard_path)
    expect(match.reload.approved_vtm_match).to be(false)
  end

  it "denies imports for non-devops users" do
    login_as_super_admin
    upload
    expect(response).to redirect_to(dashboard_path)
    expect(match.reload.approved_vtm_match).to be(false)
  end
end
