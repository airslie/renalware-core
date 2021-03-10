# frozen_string_literal: true

require "rails_helper"

describe "Advanced Kidney Care MDM", type: :system do
  it "view an MDM" do
    patient = create(:patient, family_name: "Rabbit", local_patient_id: "KCH12345")
    create(:pathology_observation_description, code: "HGB")

    login_as_clinical

    visit patient_low_clearance_mdm_path(patient)

    expect(page).to have_content(patient.to_s)
    expect(page).to have_content("Current Problems")
    expect(page).to have_content("Prescriptions")
    expect(page).to have_content("Events")
    expect(page).to have_content("Letters")
    expect(page).to have_content("Pathology")
    expect(page).to have_content("Advanced Kidney Care")
    expect(page).to have_content("Date first seen")
  end
end
