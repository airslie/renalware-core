# frozen_string_literal: true

require "rails_helper"

describe "Managing needling assessments", type: :system do
  include DateHelpers

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  it "allows adding a new needling difficulty" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    visit patient_accesses_dashboard_path(patient)

    within ".page-actions" do
      click_on t("btn.add")
      click_on t("renalware.accesses.dashboards.page_actions.needling_assessment")
    end

    expect(page).to have_current_path new_patient_accesses_needling_assessment_path(patient)
    expect(page).to have_content "New Needling Assessment"

    within("#new_needling_assessment") do
      select "moderate", from: "Difficulty"
      click_on "Save"
    end

    expect(page).to have_current_path patient_accesses_dashboard_path(patient)
  end
end
