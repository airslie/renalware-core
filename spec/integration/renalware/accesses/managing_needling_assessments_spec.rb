# frozen_string_literal: true

require "rails_helper"

describe "Managing needling assessments", type: :system do
  include DateHelpers

  it "allows adding a new needling assessment" do
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

  it "allows a superadmin to delete an assessment - see policy tests also" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    assessment = create(
      :access_needling_assessment,
      patient: patient,
      by: user,
      created_at: "12-Apr-2021"
    )
    visit patient_accesses_dashboard_path(patient)

    within "##{dom_id(assessment)}" do
      click_on t("btn.delete")
    end

    expect(page).to have_current_path patient_accesses_dashboard_path(patient)
    expect(page).not_to have_css("##{dom_id(assessment)}")
  end
end
