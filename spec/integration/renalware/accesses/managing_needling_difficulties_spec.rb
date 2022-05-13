# frozen_string_literal: true

require "rails_helper"

describe "Managing needling difficulties", type: :system do
  include DateHelpers

  # Note editing is actually a create using the current plan as a template.
  # There is no update action
  it "allows adding a new needling difficulty" do
    user = login_as_clinical
    patient = create(:accesses_patient, by: user)
    visit patient_clinical_profile_path(patient)
    within "#access-needling-difficulties" do
      click_on "Add"
    end
    expect(page).to have_current_path new_patient_accesses_needling_difficulty_path(patient)
    expect(page).to have_content "New Needling Difficulty"

    within("#new_needling_difficulty") do
      select "moderate", from: "Difficulty"
      click_on "Save"
    end

    expect(page).to have_current_path new_patient_accesses_needling_difficulty_path(patient)
  end
end
