require "rails_helper"

RSpec.describe "Searching drugs", type: :feature, js: true do

  context "given a drug matching the search term" do
    it "returns drug names that partially match" do
      user = login_as_clinician
      patient = create(:patient, by: user)
      create(:drug, name: "::drug name::")

      visit patient_prescriptions_path(
        patient, treatable_type: patient.class, treatable_id: patient
      )

      click_on "Add Prescription"
      fill_in "Drug", with: "::drug name::"

      within(".drug-results") do
        expect(page).to have_css("li", text: "::drug name::")
      end
    end
  end
end
