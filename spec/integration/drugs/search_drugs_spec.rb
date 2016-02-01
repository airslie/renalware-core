require "rails_helper"

RSpec.describe "Searching drugs", type: :feature, js: true do
  before do
    login_as_clinician
  end

  let(:patient) { create(:patient) }
  let!(:drug) { create(:drug, name: "::drug name::") }

  context "given a drug matching the search term" do
    it "returns drug names that partially match" do
      visit patient_medications_path(
        patient, treatable_type: patient.class, treatable_id: patient.id
      )

      click_on "Add medication"
      fill_in "Drug", with: "::drug name::"

      within(".drug-results") do
        expect(page).to have_css("li", text: "::drug name::")
      end
    end
  end
end
