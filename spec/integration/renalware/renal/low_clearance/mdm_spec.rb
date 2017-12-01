require "rails_helper"

RSpec.describe "Low Clearance MDM", type: :feature do
  it "view an MDM" do
    patient = create(:patient, family_name: "Rabbit", local_patient_id: "KCH12345")
    login_as_clinician
    visit patient_renal_low_clearance_mdm_path(patient)

    expect(page).to have_content(patient.to_s)
    expect(page).to have_content("Current Problems")
    expect(page).to have_content("Prescriptions")
    expect(page).to have_content("Events")
    expect(page).to have_content("Letters")
    expect(page).to have_content("Pathology")
    expect(page).to have_content("Low Clearance")
    expect(page).to have_content("Date first seen")
  end
end
