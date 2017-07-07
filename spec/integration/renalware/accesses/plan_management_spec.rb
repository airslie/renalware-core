require "rails_helper"

feature "Access Plan management", type: :feature do
  include DateHelpers
  scenario "A clinician adds a new access plan to a patient" do
    patient = create(:accesses_patient)
    login_as_clinician

    visit patient_accesses_dashboard_path(patient)

    within ".page-actions" do
      click_on "Add"
      click_on "Access Plan"
    end

    select "Continue dialysis line", from: "Plan"
  end
end
