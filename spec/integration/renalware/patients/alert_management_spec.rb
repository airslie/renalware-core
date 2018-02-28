# frozen_string_literal: true

require "rails_helper"

feature "Alert management" do
  scenario "A clinician adds an alert to a patient", js: true do
    user = login_as_clinical
    patient = create(:patient, by: user)

    visit patient_path(patient)

    click_on "Create alert"

    within "#create-alert-modal" do
      fill_in "Notes", with: "Some note"
      check "Urgent"
      click_on "Create alert"
    end

    within ".patient-alerts" do
      expect(page).to have_content("Some note")
      expect(page).to have_selector(".patient-alert", count: 1)
    end
  end

  scenario "A clinician deletes an alert", js: true do
    user = login_as_clinical
    patient = create(:patient, by: user)
    create(:patient_alert,
           patient: patient,
           by: user,
           notes: "Abc")

    visit patient_path(patient)

    within ".patient-alerts" do
      expect(page).to have_content("Abc")
      expect(page).to have_selector(".patient-alert", count: 1)
    end

    within ".patient-alerts" do
      find(".actions a").click
    end

    within ".patient-alerts" do
      expect(page).to have_selector(".patient-alert", count: 0)
    end
  end
end
