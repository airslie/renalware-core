require "rails_helper"

feature "Alert management" do

  scenario "A clinician adds an alert to a patient", js: true do
    user = login_as_clinician
    patient = create(:patient, created_by: user, updated_by: user)

    visit patient_path(patient)

    click_on "Create alert"

    within "#create-alert-modal" do
      fill_in "Notes", with: "Some note"
      check "Urgent"
      click_on "Create alert"
    end

    within ".alerts" do
      expect(page).to have_content("Some note")
      expect(page).to have_selector(".alerts--alert", count: 1)
    end
  end

  scenario "A clinician deletes an alert", js: true do
    user = login_as_clinician
    patient = create(:patient, created_by: user, updated_by: user)
    create(:patient_alert,
           patient: patient,
           created_by: user,
           updated_by: user,
           notes: "Abc")

    visit patient_path(patient)

    within ".alerts" do
      expect(page).to have_content("Abc")
      expect(page).to have_selector(".alerts--alert", count: 1)
    end

    within ".alerts" do
      find(".actions a").click
    end

    within ".alerts" do
      expect(page).to have_selector(".alerts--alert", count: 0)
    end
  end
end
