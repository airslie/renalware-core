require "rails_helper"

feature "Editing an Access Plan", type: :feature do
  include DateHelpers

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  scenario "A clinician edits an existing Access Plan causing a new current plan to be created "\
           "and the previous one tp be terminated so that it appears in the historical list" do

    user = login_as_clinician
    patient = create(:accesses_patient, by: user)
    create(:access_plan,
           patient: patient,
           notes: "Original notes",
           by: user)

    visit patient_accesses_dashboard_path(patient)

    expect(page).to have_css(".access-plans .current-access-plan")
    expect(page).to have_no_css(".historical-access-plans")

    within ".access-plans header" do
      click_on "Edit"
    end

    within "#new_accesses_plan" do
      fill_in "Notes", with: "Changed notes"
      # Other data should be pre-populated as per the plan we are cloning
      click_on "Save"
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))

    within ".access-plans .current-access-plan" do
      expect(page).to have_content("Changed notes")
    end

    within ".access-plans .historical-access-plans" do
      expect(page).to have_content("Original notes")
    end
  end

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  scenario "A clinician edits an Access Plan without changing any data, causing no new Plan "\
           "to be created" do

    user = login_as_clinician
    patient = create(:accesses_patient, by: user)
    create(:access_plan,
           patient: patient,
           notes: "Original notes",
           by: user)

    visit patient_accesses_dashboard_path(patient)

    expect(page).to have_no_css(".historical-access-plans")

    within ".access-plans header" do
      click_on "Edit"
    end

    within "#new_accesses_plan" do
      click_on "Save"
    end

    expect(page).to have_current_path(patient_accesses_dashboard_path(patient))
    expect(page).to have_no_css(".historical-access-plans")
  end
end
