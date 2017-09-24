require "rails_helper"
require "test_support/ajax_helpers"

RSpec.describe "Editing a swab", type: :feature, js: true do
  include AjaxHelpers

  it "allows a swab to be updated" do
    page.driver.add_headers("Referer" => root_path)
    user = login_as_clinician
    patient = create(:patient, by: user)

    swab_site = "The site"
    swab_result = Renalware::Events::Swab::Document.result.values.first.text
    swab = build(:swab, patient: patient, by: user)
    swab.document.result = nil
    swab.document.location = nil
    swab.save!

    visit patient_clinical_profile_path(patient)

    # On Clinical Profile..
    within("article.swabs") do
      expect(page).to have_selector("tbody tr", count: 1)
      expect(page).to have_no_content(swab_site)
      expect(page).to have_no_content(swab_result)
      click_on "Edit"
    end

    # Edit..
    fill_in "Site", with: swab_site
    choose swab_result
    click_on "Save"

    # Back on Clinical Profile..
    expect(page.current_path).to eq(patient_clinical_profile_path(patient))
    within("article.swabs") do
      expect(page).to have_selector("tbody tr", count: 1)
      expect(page).to have_content(swab_site)
      expect(page).to have_content(swab_result)
      click_on "Edit"
    end
  end
end
