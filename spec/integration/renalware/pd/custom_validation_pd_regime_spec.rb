require "rails_helper"

module Renalware
  feature "Validate for at least one bag per PD regime", js: true do
    include PatientsSpecHelper

    scenario "creating a CAPD regime without a bag should fail validation" do
      patient = create(:patient)
      set_modality(patient: patient,
                   modality_description: create(:pd_modality_description),
                   by: User.first)

      login_as_clinician
      visit patient_pd_dashboard_path(patient)

      within ".page-actions" do
        click_link "Add"
        click_link "CAPD Regime"
      end

      select "CAPD 3 exchanges per day", from: "Treatment"

      click_on "Save"

      expect(page).to have_content("Regime must be assigned at least one bag")
    end
  end
end
